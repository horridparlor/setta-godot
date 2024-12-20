extends SubmitButton

@onready var button : Button = $Button;

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

func make_primary() -> void:
	button.add_theme_stylebox_override("focus", load("res://Styles/Login/Widgets/GreenSubmitButton/GreenSubmitButtonFocus.tres"));
	button.add_theme_stylebox_override("hover", load("res://Styles/Login/Widgets/GreenSubmitButton/GreenSubmitButtonHover.tres"));
	button.add_theme_stylebox_override("normal", load("res://Styles/Login/Widgets/GreenSubmitButton/GreenSubmitButtonNormal.tres"));
	button.add_theme_stylebox_override("pressed", load("res://Styles/Login/Widgets/GreenSubmitButton/GreenSubmitButtonPressed.tres"));

func make_secondary() -> void:
	button.add_theme_stylebox_override("focus", load("res://Styles/Login/Widgets/SubmitButton/SubmitButtonFocus.tres"));
	button.add_theme_stylebox_override("hover", load("res://Styles/Login/Widgets/SubmitButton/SubmitButtonHover.tres"));
	button.add_theme_stylebox_override("normal", load("res://Styles/Login/Widgets/SubmitButton/SubmitButtonNormal.tres"));
	button.add_theme_stylebox_override("pressed", load("res://Styles/Login/Widgets/SubmitButton/SubmitButtonPressed.tres"));
