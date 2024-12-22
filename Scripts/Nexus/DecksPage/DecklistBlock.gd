extends DecklistBlock

@onready var label : RichTextLabel = $Label;
@onready var frame_layer : Node2D = $FrameLayer;
@onready var active_trash_sprite : Sprite2D = $TrashButton/TrashIconActive;
@onready var inactive_trash_sprite : Sprite2D = $TrashButton/TrashIconInactive;
@onready var down_arrow_sprite : Sprite2D = $CollapseButton/DownArrowSprite;

func init(new_block : NexusEnums.DecklistBlock) -> void:
	block = new_block;
	visible = System.DecklistBlock.is_deck_master(block);
	update_icons();
	update_label();
	update_frame();
	toggle_active();
	init_down_arrow();
	toggle_collapsed();

func init_down_arrow() -> void:
	down_arrow_sprite.texture = load(WHITE_DOWN_ARROW_PATH if block == NexusEnums.DecklistBlock.SIDE else BLACK_DOWN_ARROW_PATH);

func get_block_name() -> String:
	return NexusEnums.DecklistBlockNames[block]

func update_label() -> void:
	var block_name : String = get_block_name();
	var is_deck_master : bool = System.DecklistBlock.is_deck_master(block);
	var is_countless : bool = count == 0;
	var is_full_main_deck : bool = is_deck_master && count == System.Rules.MAIN_DECK_SIZE;
	label.text = COUNTLESS_LABEL_MESSAGE % block_name if is_countless \
		else FULL_LABEL_TEXT if is_full_main_deck else ONLY_COUNT_LABEL_MESSAGE % [count] \
		if is_deck_master \
		else LABEL_MESSAGE % [block_name, count];
	label.position.y = LABEL_POSITION_COUNTLESS if is_countless || is_full_main_deck else LABEL_POSITION_WITH_COUNT;
	label.add_theme_color_override("default_color", SystemEnums.TEXT_COLOR_PEARL_WHITE \
		if block == NexusEnums.DecklistBlock.SIDE else SystemEnums.TEXT_COLOR_BLACK);

func update_frame() -> void:
	System.Instance.load_child(BLOCK_BACKFRAME_PATH + System.String_.serialize(get_block_name()) + SystemEnums.get_node_extension(), frame_layer);

func _on_thrash_triggered() -> void:
	if !is_active or is_locked:
		return;
	emit_signal("trash", block);

func update_icons() -> void:
	active_trash_sprite.visible = !is_locked;
	inactive_trash_sprite.visible = is_locked;

func update_down_arrow() -> void:
	down_arrow_sprite.rotation_degrees = 0 if is_collapsed else 180;

func _on_collapse_triggered() -> void:
	emit_signal("collapse", block, !is_collapsed);
