extends DecksPage

@onready var edit_button : SubmitButton = $TopBar/EditButton;
@onready var catalogue_layer : Zone = $CatalogueLayer;
@onready var behind_layer : Zone = $BehindLayer;
@onready var between_layer : Node2D = $BetweenLayer;
@onready var sky : Zone = $Sky;
@onready var top_bar : Node2D = $TopBar;
@onready var decklist_form : DecklistForm = $DecklistForm;

@onready var catalogue_click_timer : Timer = $Timers/CatalogueClickTimer;
@onready var double_click_timer : Timer = $Timers/DoubleClickTimer;

func _physics_process(delta : float) -> void:
	if is_scrolling_catalogue:
		scroll_catalogue(delta);
	if is_scrolling_decklist:
		scroll_decklist(delta);
	if is_moving_catalogue_layer:
		move_catalogue_layer(delta);
	if is_moving_decklist_layer:
		move_decklist_layer(delta);

func move_catalogue_layer(delta : float) -> void:
	var limited_target : Vector2 = Vector2(catalogue_layer_target_position.x,
		limit_catalogue_layer_y(catalogue_layer_target_position.y));
	if !is_active:
		return;
	catalogue_layer.position = System.Vectors.slide_towards(catalogue_layer.position,
		catalogue_layer_target_position, CARD_CATALOGUE_SCROLL_SPEED, delta);
	catalogue_layer.position.y = limit_catalogue_layer_y(catalogue_layer.position.y);
	if System.Vectors.equal(catalogue_layer.position, limited_target):
		is_moving_catalogue_layer = false;
		catalogue_layer.position = limited_target;
	behind_layer.position = catalogue_layer.position;
	if focused_card || catalogue_cards.is_empty():
		return;
	update_card_carousel();

func limit_decklist_form_y(y : float) -> float:
	return min(DECKLIST_FORM_MAX_Y, max(DECKLIST_FORM_MAX_Y + decklist_form.min_y + DECKLIST_FORM_DEFAULT_RANGE - (PageButtons.SIZE.y if !in_edit_mode else 0), y));

func move_decklist_layer(delta : float) -> void:
	var limited_target : Vector2 = Vector2(decklist_form_target_position.x,
		limit_decklist_form_y(decklist_form_target_position.y));
	decklist_form.position = System.Vectors.slide_towards(decklist_form.position,
		decklist_form_target_position, DECKLIST_SCROLL_SPEED, delta);
	decklist_form.position.y = limit_decklist_form_y(decklist_form.position.y);
	if System.Vectors.equal(decklist_form.position, limited_target):
		is_moving_decklist_layer = false;
		decklist_form.position = limited_target;
	
func scroll_decklist(delta : float) -> void:
	var distance : float = get_global_mouse_position().y - decklist_scroll_position.y;
	if !is_moving_decklist_layer && abs(distance) < DECKLIST_MIN_SCROLL:
		return;
	decklist_form_target_position = Vector2(decklist_scroll_start_position.x, decklist_scroll_start_position.y + DECKLIST_SCROLL_MULTIPLIER * distance);
	if !is_moving_decklist_layer:
		is_moving_decklist_layer = true;

func update_card_carousel() -> void:
	var current_y : float = abs(catalogue_layer.position.y);
	var first_row_showing : int = current_y / CARD_CATALOGUE_MARGINS.y;
	var last_row_showing : int = first_row_showing + CARD_CATALOGUE_ROWS_SHOWN;
	if first_row_showing - 1 > first_row_shown:
		run_catalogue_carousel();
	elif last_row_showing < last_row_shown:
		run_catalogue_carousel(-1);

func run_catalogue_carousel(direction : int = 1) -> void:
	var card : GameplayCard;
	var cards_rotated : int = min(
		CARD_CATALOGUE_COLUMNS,
		(catalogue_cards.size() - 1 - last_card_shown) if direction > 0 else first_card_shown
	);
	var head_index : int;
	var tail_index : int;
	for i in range(cards_rotated):
		head_index = first_card_shown + i;
		tail_index = last_card_shown + i + 1;
		if direction < 0:
			head_index = last_card_shown - i;
			tail_index = first_card_shown - i - 1;
		card = cards_in_grid[head_index];
		if card == focused_card:
			drop_focused_card();
		cards.erase(card.card_data.card_id);
		card.card_data = System.CardData.from_json(catalogue_cards[tail_index]);
		cards[card.card_data.card_id] = card;
		card.Core.update_visuals(card);
		card.origin_point = card_catalogue_grid.assign_position(card.card_data.instance_id, direction);
		card.position = abs(catalogue_layer.position) + Vector2(card.origin_point.x,
			CARD_CATALOGUE_SPAWN_POINT.y if direction > 0 else CARD_CATALOGUE_TOP_SPAWN_POINT.y);
		card.is_moving = true;
		cards_in_grid.erase(card);
		cards_in_grid[tail_index] = card;
		update_card_glow(card);
	first_card_shown += direction * cards_rotated;
	last_card_shown += direction * cards_rotated;
	first_row_shown += direction;
	last_row_shown += direction;

func update_card_glow(card : GameplayCard) -> void:
	card.Core.control_glow(GameplayEnums.GlowState.SHUTTER if cards_in_decklist.has(card.card_data.card_id) else GameplayEnums.GlowState.GLOW, card, self);

func scroll_catalogue(delta : float) -> void:
	var distance : float = get_global_mouse_position().y - catalogue_scroll_position.y;
	if !is_moving_catalogue_layer and abs(distance) < CARD_CATALOGUE_MIN_SCROLL:
		return;
	catalogue_layer_target_position = Vector2(catalogue_scroll_start_position.x, catalogue_scroll_start_position.y + CARD_CATALOGUE_SCROLL_MULTIPLIER * distance);
	if !is_moving_catalogue_layer:
		is_moving_catalogue_layer = true;
		catalogue_click_timer.stop();
		focused_card = null;

func limit_catalogue_layer_y(y : float) -> float:
	return min(0, max(catalogue_layer_max_y, y));

func initialize() -> void:
	initialize_buttons();
	catalogue_layer.set_grid(card_catalogue_grid);
	behind_layer.set_grid(card_catalogue_grid);
	decklist_form.request_toggle_card.connect(toggle_card_to_decklist);
	
func initialize_buttons() -> void:
	edit_button.init("Edit");
	edit_button.pressed.connect(on_edit);

func on_edit() -> void:
	emit_signal("close_deck" if in_edit_mode else "edit_deck");

func on_edit_mode_changed() -> void:
	edit_button.unfocus();
	edit_button.set_label("Close" if in_edit_mode else "Edit");
	spawn_card_catalogue() if in_edit_mode else unspawn_cards();

func spawn_card_catalogue() -> void:
	var i : int;
	first_row_shown = 0;
	last_row_shown = CARD_CATALOGUE_ROWS_SHOWN;
	first_card_shown = 0;
	last_card_shown = CARD_CATALOGUE_MAX_CARDS_SHOWN - 1;
	find_cards();
	for card in catalogue_cards.slice(0, CARD_CATALOGUE_MAX_CARDS_SHOWN):
		cards_in_grid[i] = spawn_catalogue_card(System.CardData.from_json(card));
		i += 1;
	unlock_cards_shown();

func unlock_cards_shown() -> void:
	reset_decklist_position();
	decklist_form.toggle_locked(false);
	decklist_form.toggle_active();

func reset_decklist_position() -> void:
	decklist_form.position.y = DECKLIST_FORM_MAX_Y;

func find_cards() -> void:
	catalogue_cards = System.cards.values();
	catalogue_cards.sort_custom(System.CardData.sort_json_by_card_type);
	catalogue_layer_max_y = -CARD_CATALOGUE_MARGINS.y * (catalogue_cards.size() / CARD_CATALOGUE_COLUMNS - CARD_CATALOGUE_ROWS);

func spawn_catalogue_card(card_data : CardData) -> GameplayCard:
	var card : GameplayCard = System.Instance.load_child(SystemEnums.get_card_path(), catalogue_layer);
	card.card_data = card_data;
	cards[card_data.card_id] = card;
	card.Core.initialize(card, self);
	card.origin_point = card_catalogue_grid.assign_position(card_data.instance_id);
	card.position = CARD_CATALOGUE_SPAWN_POINT;
	card.is_moving = true;
	catalogue_layer.push_card(card, self);
	card.pressed.connect(on_card_pressed);
	card.released.connect(on_card_released);
	return card;

func on_card_pressed(card : GameplayCard) -> void:
	if focused_card != null:
		return;
	focused_card = card;
	catalogue_click_timer.start();

func drop_focused_card() -> void:
	focused_card = null;
	catalogue_click_timer.stop();

func on_card_focused() -> void:
	var card_global_position : Vector2;
	_on_catalogue_scroll_button_released();
	for c in cards.values():
		var card : GameplayCard = c;
		if card == focused_card:
			continue;
		card_global_position = card.global_position;
		behind_layer.push_card(card, self);
		card.global_position = card_global_position
	System.Children.move(top_bar, self, between_layer);
	card_global_position = focused_card.global_position;
	focused_card.Movement.interact(focused_card, self);
	catalogue_layer.position = System.Vectors.default();
	focused_card.global_position = card_global_position;
	behind_layer.sort_algorithm_grid();

func toggle_card_to_decklist(card_data : CardData) -> void:
	var card_already_in_deck : bool = cards_in_decklist.has(card_data.card_id);
	if !is_active:
		return;
	if card_already_in_deck:
		if System.CardData.is_deck_master(card_data):
			return;
		cards_in_decklist.erase(card_data.card_id);
	else:
		cards_in_decklist[card_data.card_id] = card_data;
	decklist_form.toggle_card(card_data);
	if cards.has(card_data.card_id):
		update_card_glow(cards[card_data.card_id]);

func on_card_released(card : GameplayCard) -> void:
	var card_global_position : Vector2;
	var card_id : int = card.card_data.card_id;
	if card != focused_card:
		return;
	if previously_focused_card_id == card_id:
		_on_double_click_timer_timeout();
		toggle_card_to_decklist(card.card_data);
	else:
		previously_focused_card_id = card_id;
		double_click_timer.start();
	if is_moving_catalogue_layer:
		drop_focused_card();
		return;
	catalogue_click_timer.stop();
	System.Children.move(top_bar, between_layer, self);
	for c in cards.values():
		var another_card : GameplayCard = c;
		if another_card == card:
			continue;
		catalogue_layer.push_card(another_card, self);
	card_global_position = card.global_position;
	catalogue_layer.sort_algorithm_grid(card);
	card.Movement.unfocus(card, self);
	catalogue_layer.position = Vector2(catalogue_layer_target_position.x,
		limit_catalogue_layer_y(catalogue_layer_target_position.y));
	card.global_position = card_global_position;
	focused_card = null;
	update_card_glow(card);

func unspawn_cards() -> void:
	for card in cards.values():
		card.despawn(self);
	cards = {};
	card_catalogue_grid.reset();
	reset_cards_shown();

func reset_cards_shown() -> void:
	catalogue_cards = [];
	catalogue_layer.position = System.Vectors.default();
	catalogue_layer_target_position = catalogue_layer.position;
	catalogue_layer.cards = [];
	decklist_form.toggle_active(false);
	decklist_form.toggle_locked();
	reset_decklist_position();

func _on_catalogue_scroll_button_pressed() -> void:
	if !in_edit_mode || focused_card:
		return;
	catalogue_scroll_position = get_global_mouse_position();
	catalogue_scroll_start_position = catalogue_layer.position;
	is_scrolling_catalogue = true;

func _on_catalogue_scroll_button_released() -> void:
	is_scrolling_catalogue = false;

func _on_catalogue_click_timer_timeout() -> void:
	if is_moving_catalogue_layer:
		return;
	catalogue_click_timer.stop();
	on_card_focused();

func _on_double_click_timer_timeout() -> void:
	double_click_timer.stop();
	previously_focused_card_id = 0;

func _on_decklist_scroll_button_pressed() -> void:
	if focused_card:
		return;
	decklist_scroll_position = get_global_mouse_position();
	decklist_scroll_start_position = decklist_form.position;
	is_scrolling_decklist = true;

func _on_decklist_scroll_button_released() -> void:
	is_scrolling_decklist = false;
