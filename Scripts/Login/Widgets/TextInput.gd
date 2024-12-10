extends TextInput

@onready var title : Label = $Title;
@onready var input : LineEdit = $Input;

func _ready() -> void:
	input.text_submitted.connect(on_submit);

func on_submit(message: String):
	emit_signal("submit");

func init(input_title : String, placeholder_text : String, is_secret : bool = false) -> void: 
	title.text = input_title;
	input.placeholder_text = placeholder_text;
	if is_secret:
		input.secret = true;
		input.secret_character = '*';

func focus() -> void:
	input.grab_focus();

func get_text() -> String:
	return input.text;
