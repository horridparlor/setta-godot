static func focus(node : Node, layer : Node) -> void:
	layer.move_child(node, layer.get_child_count() - 1);

static func move(node : Node2D, from : Node, to : Node) -> void:
	var position : Vector2 = node.global_position;
	var rotation : float = node.global_rotation_degrees;
	from.remove_child(node);
	to.add_child(node);
	node.global_position = position;
	node.global_rotation_degrees = rotation;
