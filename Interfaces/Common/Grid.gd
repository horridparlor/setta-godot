extends Node
class_name Grid

var starting_position : Vector2;
var columns : int;
var margins : Vector2;

var current_position : Vector2;
var items : int;


func _init(starting_position_ : Vector2, columns_ : int, margins_ : Vector2):
	starting_position = starting_position_;
	columns = columns_;
	margins = margins_;
	reset();

func assign_position() -> Vector2:
	var position : Vector2 = current_position;
	items += 1;
	if items % columns == 0:
		current_position = Vector2(starting_position.x, current_position.y + margins.y);
	else:
		current_position.x += margins.x;
	return position;

func reset() -> void:
	current_position = starting_position;
	items = 0;
