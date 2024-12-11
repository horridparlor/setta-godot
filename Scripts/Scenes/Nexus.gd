extends Nexus

@onready var page_buttons : PageButtons = $PageButtons;
@onready var logout_button : SubmitButton = $Topbar/LogoutButton;

func init() -> void:
	initialize_buttons();

func _process(delta: float) -> void:
	if is_moving_pages:
		previous_page.position = System.Vectors.slide_towards(previous_page.position,
			Vector2(page_slide_direction * System.Window_.x, 0), PAGE_SLIDE_SPEED, delta);
		active_page.position = System.Vectors.slide_towards(active_page.position,
			Vector2(0, 0), PAGE_SLIDE_SPEED, delta);
		if is_moving_pages_blockingly and System.Vectors.equal(active_page.position,
		System.Vectors.default(), PAGE_SLIDE_STOP_BLOCKING_DISTANCE):
			page_buttons.toggle_active();
			is_moving_pages_blockingly = false;
		if System.Vectors.equal(active_page.position):
			active_page.position.x = 0;
			is_moving_pages = false;
			previous_page.queue_free();

func initialize_buttons() -> void:
	page_buttons.page_switched.connect(on_page_switched);
	page_buttons.init(random);
	logout_button.init("Logout", random);
	logout_button.pressed.connect(on_logout);

func on_page_switched(nexus_page : NexusEnums.NexusPage) -> void:
	match nexus_page:
		NexusEnums.NexusPage.SHOP:
			load_page(nexus_page);
		NexusEnums.NexusPage.DECKS:
			load_page(nexus_page);
		NexusEnums.NexusPage.BATTLE:
			load_battle_page();
		NexusEnums.NexusPage.ROGUE:
			load_page(nexus_page);
		NexusEnums.NexusPage.NEWS:
			load_page(nexus_page);

func load_battle_page() -> void:
	var battle_page : BattlePage;
	load_page(NexusEnums.NexusPage.BATTLE);
	battle_page = active_page;
	battle_page.enter_game.connect(on_play);

func get_page_path(nexus_page : NexusEnums.NexusPage) -> String:
	match nexus_page:
		NexusEnums.NexusPage.SHOP:
			return SHOP_PAGE_PATH;
		NexusEnums.NexusPage.DECKS:
			return DECKS_PAGE_PATH;
		NexusEnums.NexusPage.BATTLE:
			return BATTLE_PAGE_PATH;
		NexusEnums.NexusPage.ROGUE:
			return ROGUE_PAGE_PATH;
		NexusEnums.NexusPage.NEWS:
			return NEWS_PAGE_PATH;
	return BATTLE_PAGE_PATH;

func load_page(page : NexusEnums.NexusPage) -> void:
	previous_page = active_page;
	active_page = System.Instance.load_child(get_page_path(page), self);
	active_page.init(page, random);
	if previous_page:
		previous_page.toggle_active(false);
		page_slide_direction = 1 if active_page.is_before(previous_page) else -1;
		active_page.position.x = -page_slide_direction * System.Window_.x;
		is_moving_pages = true;
		is_moving_pages_blockingly = true;
	else:
		page_buttons.toggle_active();

func on_logout() -> void:
	emit_signal("logout");

func on_play() -> void:
	emit_signal("enter_game");
