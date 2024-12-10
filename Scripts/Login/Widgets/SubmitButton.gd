extends SubmitButton

@onready var button: Button = $Button;

func _ready() -> void:
	button.pressed.connect(on_pressed);

func init(button_label: String, random : RandomNumberGenerator = null) -> void:
	button.text = button_label;
	if random:
		activate_animations(random);

func press() -> void:
	button.grab_focus();
	on_pressed();

func on_pressed() -> void:
	emit_signal("pressed");
