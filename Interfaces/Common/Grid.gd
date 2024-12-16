extends Node
class_name Grid

var starting_position : Vector2;
var starting_tail_position : Vector2;
var columns : int;
var margins : Vector2;

var head_position : Vector2;
var tail_position : Vector2;
var origin_points : Dictionary;
var items : int;

func _init(starting_position_ : Vector2, columns_ : int, margins_ : Vector2, items_ : int):
	starting_position = starting_position_;
	columns = columns_;
	margins = margins_;
	items = items_;
	starting_tail_position = Vector2(
		starting_position.x + (columns - items % columns) * margins.x,
		starting_position.y - (items / columns + 1) * margins.y
	);
	reset();

func assign_position(instance_id : int =  0, direction : int = 1) -> Vector2:
	var position : Vector2 = head_position if direction > 0 else tail_position;
	if instance_id:
		origin_points[instance_id] = position;
	move_forward() if direction > 0 else move_backward();
	return position;

func move_forward() -> void:
	head_position = move_position_forward(head_position);
	tail_position = move_position_forward(tail_position);

func move_position_forward(position : Vector2) -> Vector2:
	if position.x < starting_position.x + (columns - 1) * margins.x:
		position.x += margins.x;
	else:
		position = Vector2(starting_position.x, position.y + margins.y);
	return position;

func move_backward() -> void:
	head_position = move_position_backward(head_position);
	tail_position = move_position_backward(tail_position);

func move_position_backward(position : Vector2) -> Vector2:
	if position.x > starting_position.x:
		position.x -= margins.x;
	else:
		position = Vector2(starting_position.x + (columns - 1) * margins.x, position.y - margins.y);
	return position;

func get_origin_point(instance_id : int) -> Vector2:
	return origin_points[instance_id];

func reset() -> void:
	head_position = starting_position;
	tail_position = starting_tail_position;
