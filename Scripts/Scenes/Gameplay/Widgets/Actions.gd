static func widget_pressed(widget_type : GameplayEnums.WidgetType, gameplay : Gameplay) -> void:
	var has_open : bool = has_widget_open(widget_type, gameplay);
	if (!has_open and !gameplay.no_focus()):
		return;
	if gameplay.do_interact():
		close_widget(widget_type, gameplay);
	else:
		open_widget(widget_type, gameplay);

static func has_widget_open(widget_type : GameplayEnums.WidgetType, gameplay : Gameplay) -> bool:
	return gameplay.active_widget == widget_type;

static func open_widget(widget_type : GameplayEnums.WidgetType, gameplay : Gameplay) -> void:
	match widget_type:
		GameplayEnums.WidgetType.EXTRA_DECK:
			show_extra_deck(gameplay);
	gameplay.focus_on = GameplayEnums.FocusOn.MODAL;
	gameplay.active_widget = widget_type;
	gameplay.focus_state = GameplayEnums.FocusState.WAITING;
	gameplay.Timers.start(GameplayEnums.TimerType.ZoneFocus, gameplay);

static func widget_released(widget_type : GameplayEnums.WidgetType, gameplay : Gameplay) -> void:
	var do_wait : bool = gameplay.do_wait();
	if !has_widget_open(widget_type, gameplay) and \
	 (!do_wait and !gameplay.do_examine()):
		return;
	gameplay.Timers.stop(GameplayEnums.TimerType.ZoneFocus, gameplay);
	if do_wait:
		gameplay.focus_state = GameplayEnums.FocusState.INTERACT;
	else:
		close_widget(widget_type, gameplay);

static func close_widget(widget_type : GameplayEnums.WidgetType, gameplay : Gameplay) -> void:
	match widget_type:
		GameplayEnums.WidgetType.EXTRA_DECK:
			hide_extra_deck(gameplay);
	gameplay.release_focus();

static func show_extra_deck(gameplay : Gameplay) -> void:
	if !gameplay.no_focus():
		return;
	var cards : Array = gameplay.game_state.you.cards_in_extra_deck;
	gameplay.GameManager.render_cards(cards, gameplay.modal, gameplay);

static func hide_extra_deck(gameplay : Gameplay) -> void:
	var cards : Array = gameplay.game_state.you.cards_in_extra_deck;
	gameplay.GameManager.delete_cards(cards, gameplay.sky, gameplay);

static func zone_focus_timeout(gameplay : Gameplay) -> void:
	gameplay.Timers.stop(GameplayEnums.TimerType.ZoneFocus, gameplay);
	gameplay.focus_state = GameplayEnums.FocusState.EXAMINE;
