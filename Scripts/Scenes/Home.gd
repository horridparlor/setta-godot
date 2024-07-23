extends Home

@onready var scene_layer : Node2D = $Scenes;
@onready var debug_prompt : LineEdit = $DebugPrompt;

func _ready() -> void:
	initialize_regex();
	load_cards();
	gameplay = System.Instance.load_child(GAMEPLAY_PATH, scene_layer);
	update_debug_tools();
	set_process_input(true);
	if System.is_ready:
		gameplay.init();

func load_cards() -> void:
	var cards : Dictionary;
	System.init();
	cards = System.Json.read(SystemEnums.SaveFilePath[SystemEnums.SaveFile.CARDS]);
	if System.Json.success(cards):
		set_cards(cards.cards);
	else:
		System.Server.request(RequestEnums.Operation.GET_CARDS, {}, self);

func _on_http_response(operation : RequestEnums.Operation, response : Dictionary) -> void:
	match operation:
		RequestEnums.Operation.GET_CARDS:
			set_cards(response.cards);
			gameplay.init();

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
