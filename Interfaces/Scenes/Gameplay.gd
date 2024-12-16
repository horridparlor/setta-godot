extends CardScene
class_name Gameplay

signal surrender();

const FOCUS_FOLLOW_DISTANCE : int = 160;
const HINT_TRIBUTE : String = "[center]Tribute [b]%s[/b] [i]more monsters[/i][/center]";

var random : RandomNumberGenerator = RandomNumberGenerator.new();
var game_state : GameState;
var focus_point : Vector2;
var focus_on : GameplayEnums.FocusOn = GameplayEnums.FocusOn.NONE;
var active_widget : GameplayEnums.WidgetType = GameplayEnums.WidgetType.NONE;
var focus_state : GameplayEnums.FocusState = GameplayEnums.FocusState.NONE;
var active_modal : GameplayEnums.CardModalType = GameplayEnums.CardModalType.NONE;
var actions_left : int;
var play_type : GameplayEnums.PlayType;

func update_player_stats() -> void:
	pass;

func no_focus() -> bool:
	return focus_on == GameplayEnums.FocusOn.NONE;

func release_focus() -> void:
	if focus_on == GameplayEnums.FocusOn.CARD and active_widget != GameplayEnums.WidgetType.NONE:
		focus_on = GameplayEnums.FocusOn.MODAL;
		return;
	focus_on = GameplayEnums.FocusOn.NONE;
	active_widget = GameplayEnums.WidgetType.NONE;
	focus_state = GameplayEnums.FocusState.NONE;
	after_release();

func release_modal(card : GameplayCard) -> void:
	active_modal = GameplayEnums.CardModalType.NONE;
	selection_type = GameplayEnums.SelectionType.NONE;
	card.Movement.unfocus(card, self);

func after_release() -> void:
	pass;

func do_interact() -> bool:
	return focus_state == GameplayEnums.FocusState.INTERACT;

func do_wait() -> bool:
	return focus_state in [GameplayEnums.FocusState.INTERACT, GameplayEnums.FocusState.WAITING];
	
func do_examine() -> bool:
	return focus_state in [GameplayEnums.FocusState.INTERACT, GameplayEnums.FocusState.WAITING];
