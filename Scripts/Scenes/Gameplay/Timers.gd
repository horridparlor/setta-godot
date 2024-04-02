static func start(timer_type : GameplayEnums.TimerType, gameplay : Gameplay) -> void:
	get_timer(timer_type, gameplay).start();

static func stop(timer_type : GameplayEnums.TimerType, gameplay : Gameplay) -> void:
	get_timer(timer_type, gameplay).stop();
	
static func get_timer(timer_type : GameplayEnums.TimerType, gameplay : Gameplay) -> Timer:
	match timer_type:
		GameplayEnums.TimerType.CardFocus:
			return gameplay.card_focus_timer;
		GameplayEnums.TimerType.ZoneFocus:
			return gameplay.zone_focus_timer;
	return null;
