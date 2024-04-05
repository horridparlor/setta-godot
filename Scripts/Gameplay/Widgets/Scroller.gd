extends Scroller

@onready var modal : GameplayModalZone = $Modal;

func _on_scroll_button_pressed():
	focus_position = get_global_mouse_position();
	focus_state = GameplayEnums.FocusState.INTERACT;
	min_y = modal.get_min_y();
	max_y = modal.get_max_y();
	
func _on_scroll_button_released():
	focus_state = GameplayEnums.FocusState.NONE;

func _process(delta : float):
	var distance : float;
	var mouse_position : Vector2 = get_global_mouse_position();
	if focus_state == GameplayEnums.FocusState.INTERACT:
		origin_point.y = min(max_y, max(min_y, origin_point.y + (mouse_position.y - focus_position.y)));
		focus_position = mouse_position;
	distance = abs(origin_point.y - modal.position.y);
	if !is_moving and distance < MIN_DISTANCE:
		return;
	else:
		is_moving = true;
	modal.position = modal.position.move_toward(
		Vector2(0, origin_point.y), max(MIN_SPEED, distance * SCROLL_SPEED * delta));
	if System.Vectors.equal(modal.position, origin_point):
		modal.position = origin_point;
		is_moving = false;

func reset_children() -> void:
	modal.position = System.Vectors.default();
