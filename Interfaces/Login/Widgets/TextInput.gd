extends Control
class_name TextInput

signal submit();

func init(input_title : String, placeholder_text : String, is_secret : bool = false) -> void:
	pass;

func focus() -> void:
	pass;

func get_text() -> String:
	return "";
