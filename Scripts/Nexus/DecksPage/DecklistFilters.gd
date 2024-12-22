extends DecklistFilters

@onready var card_type_selector : OptionButton = $FiltersForm/TypeFilters/CardTypeSelector;

@onready var modulate_timer : Timer = $Timers/ModulateTimer;

func _ready() -> void:
	set_selector_options();

func set_selector_options() -> void:
	set_type_selector_options();

func set_type_selector_options() -> void:
	set_card_type_selector_options();

func set_card_type_selector_options() -> void:
	card_type_selector.add_item("–");
	for option in CardEnums.CardType.values():
		if option == CardEnums.CardType.NONE:
			continue;
		card_type_selector.add_item(CardEnums.CardTypeName[option]);

func _physics_process(delta : float) -> void:
	if is_opening:
		modulate.a = 1 - (modulate_timer.time_left - EXTRA_WAIT) / OPEN_WAIT;
	elif is_closing:
		modulate.a = (modulate_timer.time_left - EXTRA_WAIT) / CLOSE_WAIT;

func init() -> void:
	modulate_timer.wait_time = OPEN_WAIT + EXTRA_WAIT;
	is_opening = true;
	modulate_timer.start();

func _on_close_modal_triggered() -> void:
	if !is_active:
		return;
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
	
