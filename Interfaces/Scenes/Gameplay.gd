extends Node2D
class_name Gameplay

const FOCUS_FOLLOW_DISTANCE : int = 160;

var cards : Dictionary;
var focused_card : GameplayCard;
var random : RandomNumberGenerator = RandomNumberGenerator.new();
var game_state : GameState;
var focus_point : Vector2;
var focus_on : GameplayEnums.FocusOn = GameplayEnums.FocusOn.NONE;
var active_widget : GameplayEnums.WidgetType = GameplayEnums.WidgetType.NONE;
var focus_state : GameplayEnums.FocusState = GameplayEnums.FocusState.NONE;

func update_player_stats() -> void:
	pass;

func no_focus() -> bool:
	return focus_on == GameplayEnums.FocusOn.NONE;

func release_focus() -> void:
	focus_on = GameplayEnums.FocusOn.NONE;
	active_widget = GameplayEnums.WidgetType.NONE;
	focus_state = GameplayEnums.FocusState.NONE;

func do_interact() -> bool:
	return focus_state == GameplayEnums.FocusState.INTERACT;

func do_wait() -> bool:
	return focus_state in [GameplayEnums.FocusState.INTERACT, GameplayEnums.FocusState.WAITING];
	
func do_examine() -> bool:
	return focus_state in [GameplayEnums.FocusState.INTERACT, GameplayEnums.FocusState.WAITING];
