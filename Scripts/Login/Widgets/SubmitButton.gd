extends SubmitButton

@onready var button: Button = $Button;

func _ready() -> void:
	button.pressed.connect(on_pressed);

func init(button_label: String) -> void:
	set_label(button_label);
	activate_animations();

func press() -> void:
	button.grab_focus();
	on_pressed();

func on_pressed() -> void:
	emit_signal("pressed");

func set_label(button_label : String) -> void:
	button.text = button_label;

func focus() -> void:
	button.grab_focus();

func unfocus() -> void:
	button.release_focus();
