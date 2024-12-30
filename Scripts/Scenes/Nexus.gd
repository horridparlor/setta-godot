extends Nexus

@onready var page_buttons : PageButtons = $PageButtons;
@onready var page_layer : Node2D = $PageLayer;

func init() -> void:
	initialize_buttons();

func _process(delta: float) -> void:
	if is_moving_pages:
		move_pages(delta);
	if is_moving_page_buttons:
		move_page_buttons(delta);

func move_pages(delta : float) -> void:
	previous_page.position = System.Vectors.slide_towards(previous_page.position,
		Vector2(page_slide_direction * 2 * System.Window_.x, 0), PAGE_SLIDE_OUT_SPEED, delta);
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

func on_toggle_active() -> void:
	page_buttons.toggle_active(is_active);

func move_page_buttons(delta : float) -> void:
	page_buttons.position = System.Vectors.slide_towards(page_buttons.position,
		page_buttons_target_position,
		PAGE_BUTTONS_SLIDE_SPEED_DOWN if page_buttons_hidden else PAGE_BUTTONS_SLIDE_SPEED_UP,
		delta, PAGE_BUTTONS_SLIDE_MIN_SPEED_DOWN if page_buttons_hidden else PAGE_BUTTONS_SLIDE_MIN_SPEED_UP);
	if System.Vectors.equal(page_buttons.position, page_buttons_target_position):
		is_moving_page_buttons = false;
		page_buttons.position = page_buttons_target_position;

func initialize_buttons() -> void:
	page_buttons.page_switched.connect(on_page_switched);
	page_buttons.init();

func on_page_switched(nexus_page : NexusEnums.NexusPages) -> void:
	match nexus_page:
		NexusEnums.NexusPages.SHOP:
			load_page(nexus_page);
		NexusEnums.NexusPages.DECKS:
			load_decks_page();
		NexusEnums.NexusPages.BATTLE:
			load_battle_page();
		NexusEnums.NexusPages.ROGUE:
			load_page(nexus_page);
		NexusEnums.NexusPages.NEWS:
			load_page(nexus_page);

func load_battle_page() -> void:
	var battle_page : BattlePage;
	load_page(NexusEnums.NexusPages.BATTLE);
	battle_page = active_page;
	battle_page.enter_game.connect(on_play);
	battle_page.logout.connect(on_logout);

func load_decks_page() -> void:
	var decks_page : DecksPage;
	load_page(NexusEnums.NexusPages.DECKS);
	decks_page = active_page;
	decks_page.edit_deck.connect(on_edit_deck);
	decks_page.close_deck.connect(on_close_deck);

func get_page_path(nexus_page : NexusEnums.NexusPages) -> String:
	match nexus_page:
		NexusEnums.NexusPages.SHOP:
			return SHOP_PAGE_PATH;
		NexusEnums.NexusPages.DECKS:
			return DECKS_PAGE_PATH;
		NexusEnums.NexusPages.BATTLE:
			return BATTLE_PAGE_PATH;
		NexusEnums.NexusPages.ROGUE:
			return ROGUE_PAGE_PATH;
		NexusEnums.NexusPages.NEWS:
			return NEWS_PAGE_PATH;
	return BATTLE_PAGE_PATH;

func load_page(page : NexusEnums.NexusPages) -> void:
	if is_moving_pages:
		previous_page.queue_free();
	previous_page = active_page;
	active_page = System.Instance.load_child(get_page_path(page), page_layer);
	active_page.init(page);
	active_page.toast.connect(on_toast);
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
	if !System.decklists.has(System.chosen_decklist_id) || !System.decklists[System.chosen_decklist_id].isValid:
		on_toast_error("Invalid Decklist");
		return;
	toggle_active(false);
	emit_signal("enter_game");

func on_edit_deck() -> void:
	var decks_page : DecksPage = active_page;
	decks_page.toggle_edit_mode();
	decks_page.clear_filters();
	page_buttons.toggle_active(false);
	toggle_moving_page_buttons(false);

func on_close_deck() -> void:
	var decks_page : DecksPage = active_page;
	decks_page.on_close_deck();
	page_buttons.toggle_active();
	toggle_moving_page_buttons();

func toggle_moving_page_buttons(go_up : bool = true) -> void:
	page_buttons_target_position = Vector2(0, PAGE_BUTTONS_BASE_Y if go_up else PAGE_BUTTONS_HIDDEN_Y);
	is_moving_page_buttons = true;
	page_buttons_hidden = !go_up;
