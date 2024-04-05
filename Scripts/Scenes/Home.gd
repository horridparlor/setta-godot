extends Home

@onready var scene_layer : Node2D = $Scenes;
@onready var debug_prompt : LineEdit = $DebugPrompt;

func _ready() -> void:
	initialize_regex();
	gameplay = System.Instance.load_child(GAMEPLAY_PATH, scene_layer);
	debug_prompt.visible = System.DEBUG_MODE != SystemEnums.DebugMode.NONE;

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
