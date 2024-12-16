extends BattlePage

@onready var play_button : SubmitButton = $PlayButton;
@onready var logout_button : SubmitButton = $Topbar/LogoutButton;

func initialize() -> void:
	play_button.init("Play");
	play_button.pressed.connect(on_play_button_pressed);
	logout_button.init("Logout");
	logout_button.pressed.connect(on_logout);

func on_play_button_pressed() -> void:
	if !is_active:
		return;
	emit_signal("enter_game");
	
func on_logout() -> void:
	emit_signal("logout");
