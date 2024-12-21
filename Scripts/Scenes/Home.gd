extends Home

@onready var scene_layer : Node2D = $Scenes;
@onready var debug_prompt : LineEdit = $DebugPrompt;

func _ready() -> void:
	loading_icon = System.Instance.load_child(LOADING_ICON_PATH, self);
	DisplayServer.window_set_current_screen(System.Display);
	System.random.randomize();
	initialize_regex();
	update_debug_tools();
	set_process_input(true);
	System.init();
	load_cards();
	loading_icon.init();
	if !System.Auth.try_auth(self):
		initialize_login();
		return;
	load_decklists();

func _physics_process(delta : float) -> void:
	if is_moving_toasts:
		move_toasts(delta);

func move_toasts(delta : float) -> void:
	var toast : ToastMessage;
	is_moving_toasts = false;
	for t in toast_messages.values():
		toast = t;
		toast.position = System.Vectors.slide_towards(toast.position, toast.origin_point, toast.SPEED, delta);
		if System.Vectors.equal(toast.position, toast.origin_point):
			toast.position = toast.origin_point;
			toast.is_moving = false;
		else:
			is_moving_toasts = true;

func disable_loading_icon() -> void:
	if System.Instance.exists(loading_icon):
		loading_icon.queue_free();

func initialize_login(error_message : String = "") -> void:
	disable_loading_icon();
	login = System.Instance.load_child(LOGIN_PATH, scene_layer);
	login.authenticated.connect(close_login);
	login.init(error_message);

func close_login() -> void:
	initialize_nexus();
	login.queue_free();

func initialize_nexus() -> void:
	disable_loading_icon();
	if System.cards.is_empty():
		fetch_cards();
	if System.decklists.is_empty():
		fetch_decklists();
	nexus = System.Instance.load_child(NEXUS_PATH, scene_layer);
	nexus.logout.connect(on_logout);
	nexus.enter_game.connect(on_enter_game);
	nexus.toast.connect(on_toast);
	nexus.init();

func on_toast(message : String, theme : SystemEnums.ToastTheme = SystemEnums.ToastTheme.SUCCESS) -> void:
	var toast_message : ToastMessage = System.Toast.make_toast(message, theme, self);
	toast_message.despawn.connect(on_despawn_toast);
	toast_messages[toast_message.instance_id] = toast_message;
	toast_y = toast_message.position.y;
	toast_message.origin_point = toast_message.position;
	toast_message.position.y += TOAST_SPAWN_Y_MARGIN;
	reorder_toasts();

func on_despawn_toast(instance_id : int) -> void:
	var toast_message : ToastMessage = toast_messages[instance_id];
	toast_messages.erase(instance_id);
	toast_message.queue_free();
	reorder_toasts();

func reorder_toasts() -> void:
	var current_y : float = toast_y;
	var messages : Array = toast_messages.values();
	messages.reverse();
	for toast in messages:
		toast.origin_point.y = current_y;
		toast.is_moving = true;
		current_y -= TOAST_Y_MARGIN;
	is_moving_toasts = toast_messages.size();

func on_logout() -> void:
	initialize_login();
	nexus.queue_free();

func on_enter_game() -> void:
	initialize_gameplay();
	nexus.queue_free();

func initialize_gameplay() -> void:
	gameplay = System.Instance.load_child(GAMEPLAY_PATH, scene_layer);
	gameplay.surrender.connect(on_surrender);
	if System.is_ready:
		gameplay.init();

func on_surrender() -> void:
	initialize_nexus();
	gameplay.queue_free();

func load_cards() -> void:
	var cards : Dictionary;
	cards = System.Json.read(SystemEnums.SaveFilePath[SystemEnums.SaveFile.CARDS]);
	if System.Json.success(cards):
		set_cards(cards.cards);
	fetch_cards();

func fetch_cards() -> void:
	System.Server.request(RequestEnums.Operation.GET_CARDS, {'isGame': true}, self);

func _on_http_response(request : OperationRequest, operation : RequestEnums.Operation, response : Dictionary) -> void:
	match operation:
		RequestEnums.Operation.AUTHENTICATE:
			if response.has("error"):
				initialize_login(response.error);
			else:
				System.Auth.eat(response);
				initialize_nexus();
		RequestEnums.Operation.GET_CARDS:
			if response.has("error"):
				initialize_login(response.error);
				return;
			set_cards(response.cards);
			if System.Instance.exists(gameplay):
				gameplay.init();
		RequestEnums.Operation.GET_DECKLISTS:
			if response.has("error"):
				on_toast(response.error, SystemEnums.ToastTheme.FAILURE);
				return;
			System.Decklist.set_decklists_from_json(response.decklists);

func set_cards(source : Array):
	var cards : Dictionary;
	var extra_deck_cards : Dictionary;
	var main_deck_cards : Dictionary;
	var card_data : CardDefaultData;
	var json_data : Dictionary;
	var card_id : int;
	for card in source:
		card_data = CardDefaultData.new(card);
		json_data = card_data.to_json();
		card_id = card.cardId if card.errataOfId == null else card.errataOfId;
		cards[card_id] = json_data;
		card_data.queue_free();
		if System.CardData.is_main_deck(card_data):
			main_deck_cards[card_id] = json_data;
		else:
			extra_deck_cards[card_id] = json_data;
	System.cards = cards;
	System.main_deck_cards = main_deck_cards;
	System.extra_deck_cards = extra_deck_cards;
	System.Json.write({"cards": source}, SystemEnums.SaveFilePath[SystemEnums.SaveFile.CARDS]);
	System.is_ready = true;

func load_decklists() -> void:
	var decklists : Dictionary;
	decklists = System.Json.read(SystemEnums.SaveFilePath[SystemEnums.SaveFile.DECKLISTS]);
	if System.Json.success(decklists):
		System.Decklist.set_decklists_from_json(decklists.decklists);
	fetch_decklists();

func fetch_decklists() -> void:
	System.Server.request(RequestEnums.Operation.GET_DECKLISTS, {}, self);

func update_debug_tools() -> void:
	debug_prompt.visible = System.debug_mode != SystemEnums.DebugMode.NONE;

func initialize_regex() -> void:
	id_regex.compile("^[0-9]*;$");
	cheat_deal_regex.compile("^deal (\\d+00)\\;$");
	cheat_discard_regex.compile("^discard (\\d+)\\;$");
	cheat_draw_regex.compile("^draw (\\d+)\\;$");
	cheat_gain_regex.compile("^gain (\\d+00)\\;$");
	cheat_mill_regex.compile("^mill (\\d+)\\;$");

func _process(delta : float) -> void:
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit();

func _on_debug_prompt_text_changed(text : String) -> void:
	if System.String_.last(text) != ";":
		return;
	if id_regex.search(text):
		System.debug_id = int(text);
	else:
		check_cheat_codes(text);

func check_cheat_codes(text : String) -> void:
	try_cheat_deal(text) or\
	try_cheat_discard(text) or\
	try_cheat_draw(text) or\
	try_cheat_gain(text) or\
	try_cheat_mill(text);

func try_cheat_deal(text : String) -> bool:
	var amount : RegExMatch = cheat_deal_regex.search(text);
	if amount:
		gameplay.game_state.opponent.deal(int(amount.get_string(1)));
		gameplay.update_player_stats();
		clear_debug_prompt();
		return true;
	return false;

func try_cheat_draw(text : String) -> bool:
	var amount : RegExMatch = cheat_draw_regex.search(text);
	if amount:
		gameplay.game_state.you.draw_cards(int(amount.get_string(1)));
		gameplay.GameManager.render_hand(gameplay);
		clear_debug_prompt();
		return true;
	return false;

func try_cheat_discard(text : String) -> bool:
	var amount : RegExMatch = cheat_discard_regex.search(text);
	if amount:
		gameplay.game_state.you.discard_cards(int(amount.get_string(1)));
		gameplay.GameManager.render_grave(gameplay);
		clear_debug_prompt();
		return true;
	return false;

func try_cheat_gain(text : String) -> bool:
	var amount : RegExMatch = cheat_gain_regex.search(text);
	if amount:
		gameplay.game_state.you.gain(int(amount.get_string(1)));
		gameplay.update_player_stats();
		clear_debug_prompt();
		return true;
	return false;

func try_cheat_mill(text : String) -> bool:
	var amount : RegExMatch = cheat_mill_regex.search(text);
	if amount:
		gameplay.game_state.you.mill_cards(int(amount.get_string(1)));
		gameplay.update_player_stats();
		clear_debug_prompt();
		return true;
	return false;

func clear_debug_prompt() -> void:
	debug_prompt.text = "";

func _input(event : InputEvent):
	if !(event is InputEventKey and event.pressed):
		return;
	if event.keycode == DEBUG_MODE_CODE[current_code_index]:
		current_code_index += 1;
		if current_code_index == DEBUG_MODE_CODE.size():
			enable_debug_mode();
			current_code_index = 0;
	else:
		current_code_index = 0;

func enable_debug_mode() -> void:
	var card : GameplayCard;
	System.debug_mode = SystemEnums.DebugMode.CARD_DEBUG \
		if System.debug_mode == SystemEnums.DebugMode.NONE \
		else SystemEnums.DebugMode.NONE;
	update_debug_tools();
	for instance_id in gameplay.cards:
		card = gameplay.cards[instance_id];
		card.Core.update_visuals(card);
