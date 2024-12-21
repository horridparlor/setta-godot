extends Node2D
class_name CardScene

signal toast(message, theme);

var cards : Dictionary;
var focused_card : GameplayCard;
var card_to_be_played : GameplayCard;
var selection_type : GameplayEnums.SelectionType = GameplayEnums.SelectionType.NONE;
var focus_on : GameplayEnums.FocusOn = GameplayEnums.FocusOn.NONE;
var active_widget : GameplayEnums.WidgetType = GameplayEnums.WidgetType.NONE;
var focus_state : GameplayEnums.FocusState = GameplayEnums.FocusState.NONE;
var active_modal : GameplayEnums.CardModalType = GameplayEnums.CardModalType.NONE;

func is_selecting() -> bool:
	return selection_type != GameplayEnums.SelectionType.NONE;

func on_toast(message : String, theme : SystemEnums.ToastTheme = SystemEnums.ToastTheme.SUCCESS) -> void:
	emit_signal("toast", message, theme);

func on_toast_failure(message : String) -> void:
	on_toast(message, SystemEnums.ToastTheme.FAILURE);

func on_toast_warning(message : String) -> void:
	on_toast(message, SystemEnums.ToastTheme.WARNING);
