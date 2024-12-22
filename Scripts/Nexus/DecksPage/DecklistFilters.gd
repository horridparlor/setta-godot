extends DecklistFilters

@onready var card_type_selector : EnumSelector = $FiltersForm/TypeFilters/CardTypeSelector;

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

func init_type_selectors() -> void:
	init_card_type_selector();

func init_card_type_selector() -> void:
	var options : Dictionary;
	var index : int = 1;
	for option in CardEnums.CardType.values():
		if option == CardEnums.CardType.NONE:
			continue;
		options[index] = EnumOption.new(CardEnums.CardTypeName[option], option);
		index += 1;
	card_type_selector.init("Card Type", options, CardEnums.CardType.NONE, init_filters.card_type);

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
	var filters : CardFilters = CardFilters.new(card_type_selector.get_chosen().value);
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
		card_type_selector
	];

func clear_filters() -> void:
	for selector in get_selectors():
		selector.clear();
