extends DecksPage

@onready var edit_button : SubmitButton = $TopBar/EditButton;
@onready var save_button : SubmitButton = $TopBar/SaveButton;
@onready var catalogue_layer : Zone = $CatalogueLayer;
@onready var behind_layer : Zone = $BehindLayer;
@onready var between_layer : Node2D = $BetweenLayer;
@onready var sky : Zone = $Sky;
@onready var top_bar : Node2D = $TopBar;
@onready var decklist_form : DecklistForm = $DecklistForm;
@onready var decklist_meta_data : DecklistMetaData = $DecklistMetaData;

@onready var catalogue_click_timer : Timer = $Timers/CatalogueClickTimer;
@onready var double_click_timer : Timer = $Timers/DoubleClickTimer;

@onready var search_bar : TextInput = $TopBar/SearchBar;
@onready var filters_button : SubmitButton = $TopBar/FiltersButton;
@onready var clear_filters_active_sprite : Sprite2D = $TopBar/ClearFiltersButton/CrossActiveSprite;
@onready var clear_filters_inactive_sprite : Sprite2D = $TopBar/ClearFiltersButton/CrossInactiveSprite;

func _ready() -> void:
	search_bar.init("", "Search");
	update_clear_filters_button();
	initialize_decklists();
	initialize_meta_data_signals();

func initialize_meta_data_signals() -> void:
	decklist_meta_data.name_changed.connect(on_decklist_name_change);
	decklist_meta_data.save.connect(save_deck);
	decklist_meta_data.delete.connect(delete_deck);
	decklist_meta_data.roll_deck.connect(on_roll_decklist);
	decklist_meta_data.toggle_active();

func on_roll_decklist(direction : int = 1) -> void:
	var decks : Array = decklists.keys();
	var current_index : int = decks.find(System.chosen_decklist_id) + direction;
	if decks.is_empty():
		on_toast_warning("No saved decklist");
		return;
	if current_index < 0:
		current_index = decks.size() - 1;
	elif current_index >= decks.size():
		current_index = 0;
	System.chosen_decklist_id = decks[current_index];
	on_toast("Decklist %s/%s" % [current_index + 1, decks.size()]);
	load_previously_chosen_decklist();

func on_decklist_name_change(message : String) -> void:
	if message == chosen_decklist.decklist_name:
		return;
	chosen_decklist.decklist_name = message;
	chosen_decklist.has_unsaved_changes = true;

func _physics_process(delta : float) -> void:
	if is_scrolling_catalogue:
		scroll_catalogue(delta);
	if is_scrolling_decklist:
		scroll_decklist(delta);
	if is_moving_catalogue_layer:
		move_catalogue_layer(delta);
	if is_moving_decklist_layer:
		move_decklist_layer(delta);
	if is_moving_meta_data:
		move_meta_data_layer(delta);

func move_meta_data_layer(delta : float) -> void:
	decklist_meta_data.position = System.Vectors.slide_towards(
		decklist_meta_data.position,
		meta_data_origin_point,
		META_DATA_MOVE_IN_SPEED if meta_data_origin_point == META_DATA_ACTIVE_POSITION else META_DATA_MOVE_OUT_SPEED,
		delta
	);
	if System.Vectors.equal(decklist_meta_data.position, meta_data_origin_point):
		decklist_meta_data.position = meta_data_origin_point;
		is_moving_meta_data = false;

func initialize_decklists() -> void:
	var decklist : DecklistData;
	for json_data in System.decklists.values():
		decklist = DecklistData.new();
		decklist.eat_json(json_data);
		decklists[decklist.decklist_id] = decklist;
	load_previously_chosen_decklist();

func load_previously_chosen_decklist() -> void:
	if decklists.is_empty():
		spawn_new_decklist();
		return;
	chosen_decklist = decklists[System.chosen_decklist_id] if decklists.has(System.chosen_decklist_id) else decklists.values()[0];
	eat_chosen_decklist();
	save_decklists_state();

func spawn_new_decklist(json_data : Dictionary = {}) -> void:
	chosen_decklist = DecklistData.new();
	if !json_data.is_empty():
		chosen_decklist.eat_cards_json(json_data);
	chosen_decklist.has_unsaved_changes = true;
	eat_chosen_decklist();

func eat_chosen_decklist() -> void:
	chosen_deck_master = null;
	decklist_form.eat_decklist(chosen_decklist);
	cards_in_decklist = chosen_decklist.get_cards_in_decklist();
	update_chosen_deckmaster();
	update_meta_data();

func update_meta_data() -> void:
	decklist_meta_data.eat_decklist(chosen_decklist);

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
	if !is_active:
		return;
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
		(catalogue_cards.size() - 1 - last_card_shown) if direction > 0 else first_card_shown \
			if last_card_shown + 1 < catalogue_cards.size() else catalogue_cards.size() % CARD_CATALOGUE_COLUMNS
	);
	var head_index : int;
	var tail_index : int;
	if cards_rotated == 0:
		return;
	for i in range(cards_rotated):
		head_index = first_card_shown + i;
		tail_index = last_card_shown + i + 1;
		if direction < 0:
			head_index = last_card_shown - i;
			tail_index = first_card_shown - i - 1;
		card = cards_in_grid[head_index];
		if card == focused_card:
			drop_focused_card();
		cards.erase(card.card_data.errata_of_id);
		card.card_data = catalogue_cards[tail_index];
		cards[card.card_data.errata_of_id] = card;
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
	card.Core.control_glow(GameplayEnums.GlowState.SHUTTER if cards_in_decklist.has(card.card_data.errata_of_id) else GameplayEnums.GlowState.GLOW, card, self);

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
	decklist_form.request_toggle_card.connect(toggle_card_to_deck);
	decklist_form.deckmaster_counts_changed.connect(update_chosen_deckmaster);
	decklist_form.reference_card.connect(on_reference_card);
	decklist_form.toast.connect(on_toast);

func on_reference_card(card_data : CardData) -> void:
	var is_currently_referenced : bool = card_data.errata_of_id == decklist_form.referenced_card.errata_of_id if decklist_form.referenced_card else false;
	if !in_edit_mode || !has_deck_master() || decklist_form.get_slip(card_data).global_position.y < DECKLIST_FORM_MAX_Y - decklist_form.SLIP_MARGIN.y / 2:
		return;
	if decklist_form.referenced_card == null || !is_currently_referenced:
		set_reference(card_data);
	else:
		if is_currently_referenced:
			decklist_form.referenced_card = card_data;
		clear_reference();
	find_cards();

func set_reference(card_data : CardData) -> void:
	clear_reference();
	for slip in decklist_form.get_slips_for_card(card_data):
		slip.shutter();
	decklist_form.referenced_card = card_data;
	update_clear_filters_button();
	on_toast("Referencing: %s" % card_data.normalized_name);

func initialize_buttons() -> void:
	edit_button.init("Edit");
	edit_button.make_primary();
	edit_button.pressed.connect(on_edit);
	save_button.init("Copy");
	filters_button.init("New");

func on_edit() -> void:
	if !is_active:
		return;
	emit_signal("close_deck" if in_edit_mode else "edit_deck");

func on_close_deck() -> void:
	toggle_edit_mode(false);
	clear_filters();
	chosen_decklist.eat_cards(decklist_form);
	if chosen_decklist.has_unsaved_changes:
		on_toast_warning("Unsaved changes");

func on_edit_mode_changed() -> void:
	edit_button.unfocus();
	edit_button.set_label("Close" if in_edit_mode else "Edit");
	edit_button.make_secondary() if in_edit_mode else edit_button.make_primary();
	save_button.set_label("Save" if in_edit_mode else "Copy");
	save_button.make_primary() if in_edit_mode else save_button.make_secondary();
	filters_button.set_label("Filters" if in_edit_mode else "New")
	if in_edit_mode:
		open_edit_mode();
	else:
		close_edit_mode();

func open_edit_mode() -> void:
	spawn_card_catalogue();
	meta_data_origin_point = META_DATA_AWAY_POSITION;
	decklist_meta_data.toggle_active(false);
	is_moving_meta_data = true;

func close_edit_mode() -> void:
	unspawn_cards();
	reset_decklist_position();
	meta_data_origin_point = META_DATA_ACTIVE_POSITION;
	decklist_meta_data.toggle_active();
	is_moving_meta_data = true;

func spawn_card_catalogue() -> void:
	find_cards();
	reset_decklist_position();

func unlock_decklist_cards_shown() -> void:
	decklist_form.toggle_locked(false);
	decklist_form.toggle_active();
	for card in cards.values():
		if decklist_form.card_in_any_deck(card.card_data):
			update_card_glow(card);

func reset_decklist_position() -> void:
	decklist_form.position.y = DECKLIST_FORM_MAX_Y;

func find_cards() -> void:
	if !in_edit_mode:
		return;
	unspawn_cards();
	catalogue_cards = get_filtered_cards() if has_deck_master() \
		else all_cards.filter(System.CardData.is_deck_master);
	catalogue_layer_max_y = -CARD_CATALOGUE_MARGINS.y * \
		((catalogue_cards.size() + CARD_CATALOGUE_COLUMNS - 1) / CARD_CATALOGUE_COLUMNS - CARD_CATALOGUE_ROWS);
	spawn_catalogue_cards();
	unlock_decklist_cards_shown();
	update_clear_filters_button();

func get_filtered_cards() -> Array:
	var deckmaster_legal_cards : Array = all_cards.filter(func(card : CardData): return System.CardData.can_be_with_deckmaster(card, chosen_deck_master));
	return deckmaster_legal_cards.filter(func(card : CardData): 
		return System.CardData.is_referenced_by(card, decklist_form.referenced_card)) \
		if decklist_form.referenced_card != null else filter_by_filters(deckmaster_legal_cards);

func filter_by_filters(legal_cards : Array) -> Array:
	if search_string.length():
		legal_cards = legal_cards.filter(func(card : CardData):
			return System.CardData.has_search_string(card, search_string));
	if legal_cards.is_empty():
		on_toast_warning("No cards found");
	return legal_cards;

func spawn_catalogue_cards() -> void:
	var i : int;
	for card in catalogue_cards.slice(0, CARD_CATALOGUE_MAX_CARDS_SHOWN):
		cards_in_grid[i] = spawn_catalogue_card(card);
		i += 1;

func has_deck_master() -> bool:
	return decklist_form.collection_counts[NexusEnums.DecklistBlock.DECK_MASTER];

func spawn_catalogue_card(card_data : CardData) -> GameplayCard:
	var card : GameplayCard = System.Instance.load_child(SystemEnums.get_card_path(), catalogue_layer);
	card.card_data = card_data;
	cards[card_data.errata_of_id] = card;
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

func toggle_card_to_deck(card_data : CardData) -> void:
	toggle_card_to_decklist(card_data, false, false);

func toggle_card_to_decklist(card_data : CardData, is_mass_operation : bool = false, for_all_decks : bool = true) -> void:
	var card_already_in_deck : bool = cards_in_decklist.has(card_data.errata_of_id);
	if !is_active:
		return;
	decklist_form.toggle_card(card_data, !is_mass_operation, for_all_decks);
	if card_already_in_deck:
		if !decklist_form.card_in_any_deck(card_data):
			cards_in_decklist.erase(card_data.errata_of_id);
			if decklist_form.referenced_card && card_data.errata_of_id == decklist_form.referenced_card.errata_of_id:
				decklist_form.referenced_card = null;
				find_cards();
	else:
		cards_in_decklist[card_data.errata_of_id] = card_data;
	if cards.has(card_data.errata_of_id):
		update_card_glow(cards[card_data.errata_of_id]);
	if !is_mass_operation:
		update_chosen_deckmaster();

func update_chosen_deckmaster() -> void:
	if (chosen_deck_master != null) == has_deck_master():
		return;
	if has_deck_master():
		chosen_deck_master = decklist_form.get_deck_master();
		for card in get_invalid_cards_by_deck_master():
			toggle_card_to_decklist(card, true);
	else:
		chosen_deck_master = null;
	clear_filters();
	find_cards();

func clear_filters() -> void:
	search_bar.set_text();
	search_string = "";
	clear_reference();
	update_clear_filters_button();

func clear_reference() -> void:
	if decklist_form.referenced_card:
		for slip in decklist_form.get_slips_for_card(decklist_form.referenced_card):
			slip.baseline();
	decklist_form.referenced_card = null;
	update_clear_filters_button();

func get_invalid_cards_by_deck_master() -> Array:
	var invalid_cards : Array;
	var card : CardData;
	for c in decklist_form.concat_non_backrow_collections():
		card = c;
		if card.errata_of_id != chosen_deck_master.errata_of_id && \
		!System.CardData.can_be_with_deckmaster(card, chosen_deck_master):
			invalid_cards.append(card);
	return invalid_cards;

func on_card_released(card : GameplayCard) -> void:
	var card_global_position : Vector2;
	var card_id : int = card.card_data.errata_of_id;
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
	reset_card_catalogue();
	catalogue_cards.clear();
	catalogue_layer.position = System.Vectors.default();
	catalogue_layer_target_position = catalogue_layer.position;
	catalogue_layer.cards = [];
	decklist_form.toggle_active(false);
	decklist_form.toggle_locked();

func reset_card_catalogue() -> void:
	first_row_shown = 0;
	last_row_shown = CARD_CATALOGUE_ROWS_SHOWN;
	first_card_shown = 0;
	last_card_shown = CARD_CATALOGUE_MAX_CARDS_SHOWN - 1;

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

func _on_search_bar_submit_message(message : String) -> void:
	var new_search_string : String = message.strip_edges().to_lower();
	if new_search_string == search_string || !has_deck_master():
		return;
	search_string = new_search_string;
	if in_edit_mode:
		find_cards();
	else:
		update_clear_filters_button();

func has_filters() -> bool:
	return search_string.length() || decklist_form.referenced_card != null;

func update_clear_filters_button() -> void:
	clear_filters_active_sprite.visible = has_filters();
	clear_filters_inactive_sprite.visible = !clear_filters_active_sprite.visible;

func _on_clear_filters_triggered() -> void:
	if !has_filters() || !is_active:
		return;
	clear_filters();
	if in_edit_mode:
		find_cards();

func _on_save_button_pressed() -> void:
	if !is_active:
		return;
	save_deck() if in_edit_mode else copy_deck();

func copy_deck() -> void:
	if !has_deck_master():
		on_toast_warning("No Deck Master");
		return;
	spawn_new_decklist(chosen_decklist.get_json());
	on_toast("Deck copied");

func save_deck() -> void:
	if !has_deck_master():
		on_toast_warning("No Deck Master");
		return;
	decklist_meta_data.force_unsubmitted_updates();
	chosen_decklist.eat_cards(decklist_form);
	toggle_active(false);
	if !chosen_decklist.has_unsaved_changes:
		on_toast("Deck saved");
		toggle_active(true);
		return;
	chosen_decklist.upload(self);

func delete_deck() -> void:
	if chosen_decklist.is_new():
		load_previously_chosen_decklist();
		on_toast("Deck cleared");
		return;
	toggle_active(false);
	chosen_decklist.delete(self);	

func on_delete_decklist(response : Dictionary) -> void:
	var decklist_id : int = response.decklistId;
	var decks : Array = decklists.keys();
	var current_index : int = decks.find(decklist_id) - 1;
	if decks.size() > current_index:
		System.chosen_decklist_id = decks[current_index];
	decklists.erase(decklist_id);
	load_previously_chosen_decklist();
	on_toast("Decklist deleted");
	toggle_active(true);

func _on_http_response(request : OperationRequest, operation : RequestEnums.Operation, response : Dictionary) -> void:
	match operation:
		RequestEnums.Operation.DELETE_DECKLIST:
			if response.has("error"):
				on_toast_failure(response.error);
				chosen_decklist.toggle_active();
				toggle_active();
				return;
			on_delete_decklist(response);
		RequestEnums.Operation.POST_DECKLIST:
			if response.has("error"):
				on_toast_failure(response.error);
				chosen_decklist.toggle_active();
				toggle_active();
				return;
			on_decklist_posted(response);
		RequestEnums.Operation.PUT_DECKLIST:
			if response.has("error"):
				on_toast_failure(response.error);
				chosen_decklist.toggle_active();
				toggle_active();
				return;
			on_decklist_put(response);

func on_decklist_posted(response : Dictionary) -> void:
	on_toast("Deck created");
	chosen_decklist.eat_posted(response);
	decklists[chosen_decklist.decklist_id] = chosen_decklist;
	System.chosen_decklist_id = chosen_decklist.decklist_id;
	save_decklists_state();
	toggle_active();

func on_decklist_put(response : Dictionary) -> void:
	on_toast("Deck saved");
	chosen_decklist.eat_put(response);
	save_decklists_state();
	toggle_active();

func save_decklists_state() -> void:
	System.Decklist.set_decklists(decklists);
	System.store_user_state();
	update_meta_data();
	
func _on_filters_button_pressed() -> void:
	if !is_active:
		return;
	on_filters() if in_edit_mode else on_new_deck();

func on_filters() -> void:
	close_decklist_filters() if is_filters_modal_open else open_decklist_filters();

func on_toggle_active() -> void:
	decklist_form.toggle_active(is_active && in_edit_mode);
	search_bar.toggle_active(is_active);

func on_new_deck() -> void:
	if !chosen_decklist.is_new() || !chosen_decklist.is_empty():
		spawn_new_decklist();
	on_edit();
	on_toast("Choose Deck Master");
