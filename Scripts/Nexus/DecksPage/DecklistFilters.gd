extends DecklistFilters

@onready var card_type_selector : EnumSelector = $FiltersForm/TypeFilters/CardTypeSelector;
@onready var subtype_selector : EnumSelector = $FiltersForm/TypeFilters/SubtypeSelector;
@onready var supertype_selector : EnumSelector = $FiltersForm/TypeFilters/SupertypeSelector;
@onready var deck_selector : EnumSelector = $FiltersForm/ImportantFilters/DeckSelector;
@onready var class_selector : EnumSelector = $FiltersForm/ImportantFilters/ClassSelector;
@onready var is_ace_selector : EnumSelector = $FiltersForm/ImportantFilters/IsAceSelector

@onready var filter_button : SubmitButton = $BottomButtons/FilterButton;
@onready var clear_button : SubmitButton = $BottomButtons/ClearButton;

@onready var modulate_timer : Timer = $Timers/ModulateTimer;

func _ready() -> void:
	init_buttons();

func init_buttons() -> void:
	filter_button.init("Filter");
	filter_button.make_primary();
	clear_button.init("Clear");

func init_selectors() -> void:
	init_type_selectors();
	init_important_selectors();

func init_type_selectors() -> void:
	init_card_type_selector();
	init_subtype_selector();
	init_supertype_selector();

func init_important_selectors() -> void:
	init_deck_selector();
	init_class_selector();
	init_is_ace_selector();

func init_card_type_selector() -> void:
	var options : Dictionary = System.Enums.build_options(
		CardEnums.CardType.values(), CardEnums.CardTypeName, CardEnums.CardType.NONE);
	card_type_selector.init("Card Type", options, CardEnums.CardType.NONE, init_filters.card_type);

func init_subtype_selector() -> void:
	var options : Dictionary = System.Enums.build_options(
		CardEnums.CardSubtype.values(), CardEnums.CardSubtypeName, CardEnums.CardSubtype.NONE);
	subtype_selector.init("Subtype", options, CardEnums.CardSubtype.NONE, init_filters.subtype);

func init_supertype_selector() -> void:
	var options : Dictionary = System.Enums.build_options(
		CardEnums.CardSupertype.values(), CardEnums.CardSupertypeName, CardEnums.CardSupertype.NONE);
	supertype_selector.init("Supertype", options, CardEnums.CardSupertype.NONE, init_filters.supertype);

func init_deck_selector() -> void:
	var options : Dictionary = System.Enums.build_options(
		CardEnums.DeckType.values(), CardEnums.DeckTypeName, CardEnums.DeckType.NONE);
	deck_selector.init("Deck", options, CardEnums.DeckType.NONE, init_filters.deck);

func init_class_selector() -> void:
	var options : Dictionary = System.Enums.build_options(
		CardEnums.Class.values(), CardEnums.ClassName, CardEnums.Class.NONE);
	class_selector.init("Class", options, CardEnums.Class.NONE, init_filters.card_class);

func init_is_ace_selector() -> void:
	var options : Dictionary = System.Enums.build_boolean_options("Ace");
	is_ace_selector.init("Is Ace", options, SystemEnums.BooleanOption.NONE, init_filters.is_ace);

func _physics_process(delta : float) -> void:
	if is_opening:
		modulate.a = 1 - (modulate_timer.time_left - EXTRA_WAIT) / OPEN_WAIT;
	elif is_closing:
		modulate.a = (modulate_timer.time_left - EXTRA_WAIT) / CLOSE_WAIT;

func init(filters : CardFilters) -> void:
	modulate_timer.wait_time = OPEN_WAIT + EXTRA_WAIT;
	is_opening = true;
	modulate_timer.start();
	eat_filters(filters);

func eat_filters(filters : CardFilters) -> void:
	init_filters = filters;
	init_selectors();

func _on_close_modal_triggered() -> void:
	if !is_active:
		return;
	on_close();

func on_close() -> void:
	is_closing = true;
	modulate_timer.wait_time = CLOSE_WAIT + EXTRA_WAIT;
	modulate_timer.start();

func _on_modulate_timer_timeout() -> void:
	modulate_timer.stop();
	if is_opening:
		is_opening = false;
		toggle_active();
	elif is_closing:
		is_closing = false;
		toggle_active(false);
		emit_signal("close");
	
func _on_filter_button_pressed() -> void:
	if !is_active:
		return;
	on_filter();

func on_filter() -> void:
	var filters : CardFilters = CardFilters.new(
		card_type_selector.get_value(),
		subtype_selector.get_value(),
		supertype_selector.get_value(),
		class_selector.get_value(),
		is_ace_selector.get_value(),
		deck_selector.get_value()
	);
	if filters.get_json_string() == init_filters.get_json_string():
		on_close();
		return;
	emit_signal("submit_filters", filters);

func _on_clear_button_pressed() -> void:
	if !is_active:
		return;
	clear_filters();

func get_selectors() -> Array:
	return [
		card_type_selector,
		subtype_selector,
		supertype_selector,
		deck_selector,
		class_selector,
		is_ace_selector
	];

func clear_filters() -> void:
	for selector in get_selectors():
		selector.clear();
