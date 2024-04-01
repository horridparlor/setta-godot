extends Node2D
class_name Gameplay

const FOCUS_FOLLOW_DISTANCE : int = 160;

var cards : Dictionary;
var focused_card : GameplayCard;
var random : RandomNumberGenerator = RandomNumberGenerator.new();
var game_state : GameState;
var focus_point : Vector2;

func update_player_stats() -> void:
	pass;
