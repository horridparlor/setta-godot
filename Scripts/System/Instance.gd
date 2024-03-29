static func load_child(child_path : String, parent : Node) -> Node:
	var child : Node = load(child_path).instantiate();
	parent.add_child(child);
	return child;
