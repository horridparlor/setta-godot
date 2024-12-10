extends Nexus

@onready var page_buttons : PageButtons = $PageButtons;
@onready var logout_button : SubmitButton = $LogoutButton;

func init() -> void:
	page_buttons.init(random);
	logout_button.init("Logout", random);
	logout_button.pressed.connect(on_logout);

func on_logout() -> void:
	emit_signal("logout");
