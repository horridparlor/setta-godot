extends Node
class_name PositioningData

var current_position : Vector2;

var index : int = 0;
var hop_index : int = 0;
var row_size : int = 1;
var hops : int = 0;
var fix_hops : int = 0;

func _init(starting_position : Vector2):
	current_position = starting_position;
