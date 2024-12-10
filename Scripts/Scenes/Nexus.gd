extends Nexus

@onready var page_buttons : PageButtons = $PageButtons;
@onready var logout_button : SubmitButton = $LogoutButton;
@onready var play_button : SubmitButton = $PlayButton;

func init() -> void:
	page_buttons.init(random);
	logout_button.init("Logout", random);
	logout_button.pressed.connect(on_logout);
	play_button.init("Play", random);
	play_button.pressed.connect(on_play);

func on_logout() -> void:
	emit_signal("logout");

func on_play() -> void:
	emit_signal("enter_game");
