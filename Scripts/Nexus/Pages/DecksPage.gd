extends DecksPage

@onready var edit_button : SubmitButton = $TopBar/EditButton;
@onready var catalogue_layer : Node2D = $CatalogueLayer;

func _physics_process(delta : float) -> void:
	if is_scrolling_catalogue:
		scroll_catalogue(delta);
	if is_moving_catalogue_layer:
		catalogue_layer.position = System.Vectors.slide_towards(catalogue_layer.position,
			catalogue_layer_target_position, CARD_CATALOGUE_SCROLL_SPEED, delta);
		if System.Vectors.equal(catalogue_layer.position, catalogue_layer_target_position):
			is_moving_catalogue_layer = false;
			catalogue_layer.position = catalogue_layer_target_position;

func scroll_catalogue(delta : float) -> void:
	var distance : float = get_global_mouse_position().y - scroll_position.y;
	if !is_moving_catalogue_layer and abs(distance) < CARD_CATALOGUE_MIN_SCROLL:
		return;
	catalogue_layer_target_position = Vector2(catalogue_scroll_start_position.x, get_catalogue_layer_y(CARD_CATALOGUE_SCROLL_MULTIPLIER * distance));
	is_moving_catalogue_layer = true;

func get_catalogue_layer_y(distance : float) -> float:
	var y : float = catalogue_scroll_start_position.y + distance;
	return min(0, max(catalogue_layer_max_y, y));

func initialize() -> void:
	initialize_buttons(random);
	
func initialize_buttons(random : RandomNumberGenerator) -> void:
	edit_button.init("Edit", random);
	edit_button.pressed.connect(on_edit);

func on_edit() -> void:
	emit_signal("close_deck" if in_edit_mode else "edit_deck");

func on_edit_mode_changed() -> void:
	edit_button.unfocus();
	edit_button.set_label("Close" if in_edit_mode else "Edit");
	spawn_card_catalogue() if in_edit_mode else unspawn_cards();

func spawn_card_catalogue() -> void:
	var card_data : CardData;
	var card_init_data : CardInitData = CardInitData.new(GameplayEnums.OwningPlayer.YOU, random, CardEnums.CardSleeve.DEFAULT);
	find_cards();
	for card in catalogue_cards:
		card_data = CardData.new(card.card_id, card_init_data);
		card_data.eat_default(card);
		spawn_catalogue_card(card_data);
		
func sort_by_card_name(card_a : Dictionary, card_b : Dictionary) -> int:
	return card_a.normalized_name < card_b.normalized_name;

func find_cards() -> void:
	catalogue_cards = System.cards.values();
	catalogue_cards.sort_custom(sort_by_card_name);
	catalogue_layer_max_y = -CARD_CATALOGUE_MARGINS.y * (catalogue_cards.size() / CARD_CATALOGUE_COLUMNS - CARD_CATALOGUE_ROWS);

func spawn_catalogue_card(card_data : CardData) -> void:
	var card : GameplayCard = System.Instance.load_child(SystemEnums.get_card_path(), catalogue_layer);
	card.card_data = card_data;
	card.random = random;
	cards[card_data.instance_id] = card;
	card.Core.initialize(card, self);
	card.position = card_catalogue_grid.assign_position();

func unspawn_cards() -> void:
	for card in cards.duplicate().values():
		card.queue_free();
	cards = {};
	card_catalogue_grid.reset();

func _on_catalogue_scroll_button_pressed() -> void:
	if !in_edit_mode:
		return;
	scroll_position = get_global_mouse_position();
	catalogue_scroll_start_position = catalogue_layer.position;
	is_scrolling_catalogue = true;

func _on_catalogue_scroll_button_released() -> void:
	is_scrolling_catalogue = false;
