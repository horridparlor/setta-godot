extends Home

@onready var scene_layer : Node2D = $Scenes;
@onready var debug_prompt : LineEdit = $DebugPrompt;

func _ready() -> void:
	initialize_regex();
	load_cards();
	gameplay = System.Instance.load_child(GAMEPLAY_PATH, scene_layer);
	update_debug_tools();
	set_process_input(true);

func load_cards() -> void:
	System.init();
	System.Server.request(RequestEnums.Operation.GET_CARDS, self);

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
		card_id = card.cardId;
		cards[card_id] = json_data;
		card_data.queue_free();
		if System.CardData.is_main_deck(card_data):
			main_deck_cards[card_id] = json_data;
		else:
			extra_deck_cards[card_id] = json_data;
	System.cards = cards;
	System.main_deck_cards = main_deck_cards;
	System.extra_deck_cards = extra_deck_cards;

func update_debug_tools() -> void:
	debug_prompt.visible = System.debug_mode != SystemEnums.DebugMode.NONE;

func initialize_regex() -> void:
	id_regex.compile("^[0-9]*$");
	cheat_draw_regex.compile("^draw (\\d+)\\.$");

func _process(delta : float) -> void:
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit();

func _on_debug_prompt_text_changed(text : String) -> void:
	if id_regex.search(text):
		System.debug_id = int(text);
	else:
		check_cheat_codes(text);

func check_cheat_codes(text : String) -> void:
	try_cheat_draw(text);

func try_cheat_draw(text : String) -> bool:
	var amount : RegExMatch = cheat_draw_regex.search(text);
	if amount:
		gameplay.game_state.you.draw_cards(int(amount.get_string(1)));
		gameplay.GameManager.render_hand(gameplay);
		clear_debug_prompt();
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
