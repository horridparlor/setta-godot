extends Node2D
class_name Scroller

const SCROLL_SPEED : int = 2;
const MIN_SPEED : int = 1;
const MIN_DISTANCE : int = System.Window_.y / pow(2, 4);

var focus_state : GameplayEnums.FocusState = GameplayEnums.FocusState.NONE;
var focus_position : Vector2;
var origin_point : Vector2;
var min_y : int;
var max_y : int;
var is_moving : bool;

func reset() -> void:
	origin_point = System.Vectors.default();
	reset_children();

func reset_children() -> void:
	pass;
