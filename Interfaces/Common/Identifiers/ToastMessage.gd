extends Node2D
class_name ToastMessage

signal despawn(instance_id);

const TOAST_MESSAGE_PATH : String = "res://Prefabs/Common/Identifiers/ToastMessage.tscn";
const SUCCESS_LOAD_THEME : String = "res://Styles/Common/Identifiers/ToastMessage/SuccessLoad.tres";
const FAILURE_LOAD_THEME : String = "res://Styles/Common/Identifiers/ToastMessage/FailureLoad.tres";
const WARNING_LOAD_THEME : String = "res://Styles/Common/Identifiers/ToastMessage/WarningLoad.tres";
const BACKFRAME_MARGIN : int = 15;
const SPAWN_POINT_MARGIN : Vector2 = Vector2(25, 42.5);
const DESPAWN_WAIT_SUCCESS : float = 1.4;
const DESPAWN_WAIT_FAILURE : float = 2.3;
const DESPAWN_EXTRA_WAIT : float = 0.2;
const SPEED : float = 16;

var load_panel_max_x : float;
var instance_id : int
var despawn_wait : float;
var origin_point : Vector2;
var is_moving : bool;

func init(message : String, theme : SystemEnums.ToastTheme = SystemEnums.ToastTheme.SUCCESS) -> void:
	pass;

func get_theme_path(theme : SystemEnums.ToastTheme) -> String:
	match theme:
		SystemEnums.ToastTheme.SUCCESS:
			return SUCCESS_LOAD_THEME;
		SystemEnums.ToastTheme.ERROR:
			return FAILURE_LOAD_THEME;
		SystemEnums.ToastTheme.WARNING:
			return WARNING_LOAD_THEME;
	return SUCCESS_LOAD_THEME;
