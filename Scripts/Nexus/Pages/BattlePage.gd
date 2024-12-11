extends BattlePage

@onready var play_button : SubmitButton = $PlayButton;

func initialize(random : RandomNumberGenerator) -> void:
	play_button.init("Play", random);
	play_button.pressed.connect(on_play_button_pressed);

func on_play_button_pressed() -> void:
	if !is_active:
		return;
	emit_signal("enter_game");
	
