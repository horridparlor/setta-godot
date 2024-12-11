extends Nexus

@onready var page_buttons : PageButtons = $PageButtons;
@onready var logout_button : SubmitButton = $Topbar/LogoutButton;

func init() -> void:
	page_buttons.init(random);
	logout_button.init("Logout", random);
	logout_button.pressed.connect(on_logout);
	load_battle_page();

func load_battle_page() -> void:
	var battle_page : BattlePage;
	load_page(BATTLE_PAGE_PATH);
	battle_page = active_page;
	battle_page.enter_game.connect(on_play);

func load_page(path : String) -> void:
	previous_page = active_page;
	active_page = System.Instance.load_child(path, self);
	active_page.init(random);

func on_logout() -> void:
	emit_signal("logout");

func on_play() -> void:
	emit_signal("enter_game");
