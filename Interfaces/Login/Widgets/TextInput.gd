extends Control
class_name TextInput

signal submit();
signal focused();

func init(input_title : String, placeholder_text : String, is_secret : bool = false) -> void:
	pass;

func focus() -> void:
	pass;

func unfocus() -> void:
	pass;

func get_text() -> String:
	return "";
	
func set_text(message : String) -> void:
	pass;

func set_placeholder_text(message : String) -> void:
	pass;
