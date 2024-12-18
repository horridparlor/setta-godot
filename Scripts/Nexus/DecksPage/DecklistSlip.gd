extends DecklistSlip

@onready var name_label : RichTextLabel = $NameLabel;
@onready var copy_bars : CopyBars = $CopyCounter/CopyBars;
@onready var backframe_layer : Node2D = $BackFrameLayer;
@onready var attribute_sprite : Sprite2D = $AttributeSprite;
@onready var thrash_active_sprite : Sprite2D = $ThrashIcon/ThrashActive;
@onready var thrash_inactive_sprite : Sprite2D = $ThrashIcon/ThrashInactive;
@onready var plus_active_sprite : Sprite2D = $CopyCounter/PlusIcon/PlusActive;
@onready var plus_inactive_sprite : Sprite2D = $CopyCounter/PlusIcon/PlusInactive;
@onready var minus_active_sprite : Sprite2D = $CopyCounter/MinusIcon/MinusActive;
@onready var minus_inactive_sprite : Sprite2D = $CopyCounter/MinusIcon/MinusInactive;
@onready var side_grab_label : Label = $SideGrabber/Label;
@onready var level_sprite : Sprite2D = $LevelSprite;
@onready var level_label : Label = $LevelSprite/LevelLabel;

func modulate_icons(level_modulation : float, attribute_modulation : float) -> void:
	level_sprite.modulate.a = level_modulation;
	attribute_sprite.modulate.a = attribute_modulation;

func init(new_data : CardData) -> void:
	card_data = new_data;
	name_label.text = card_data.normalized_name;
	max_copies = System.CardData.get_max_copies(card_data);
	set_copies(max_copies);
	set_backframe();
	set_attribute();
	init_level_frame();

func init_level_frame() -> void:
	var is_monster : bool = System.CardData.is_monster(card_data);
	level_sprite.visible = is_monster;
	if !is_monster:
		return;
	level_sprite.texture = load(DECK_MASTER_LEVEL_FRAME_PATH if System.CardData.is_deck_master(card_data) else LEVEL_FRAME_PATH);
	level_label.text = str(card_data.level);
	is_modulating_icons = true;

func set_backframe() -> void:
	System.Instance.load_child(BACKFRAME_PATH + System.CardData.get_middle_frame_name(card_data) + SystemEnums.get_node_extension(), backframe_layer);

func set_attribute() -> void:
	var attribute_name : String = System.CardData.get_attribute_name(card_data);
	attribute_sprite.texture = load(DECKSLIP_ATTRIBUTE_PATH + attribute_name + SystemEnums.get_image_extension());

func set_copies(new_copies : int) -> void:
	copies = new_copies;
	copy_bars.set_bars(copies, max_copies, card_data.is_ace);

func get_active_count_icons() -> Array:
	return [
		thrash_active_sprite,
		plus_active_sprite,
		minus_active_sprite
	];

func get_inactive_count_icons() -> Array:
	return [
		thrash_inactive_sprite,
		plus_inactive_sprite,
		minus_inactive_sprite
	];

func update_count_icons():
	var in_side_deck : bool = System.CardData.in_side_deck(card_data);
	side_grab_label.text = "" if is_locked else "Main" if in_side_deck else "Side";
	side_grab_label.add_theme_color_override("font_color", SystemEnums.MAIN_FRAME_COLOR_NORMAL \
		if in_side_deck else SystemEnums.MAIN_FRAME_COLOR_KILLER_MOVE);
	for icon in get_active_count_icons():
		icon.visible = !is_locked;
	for icon in get_inactive_count_icons():
		icon.visible = is_locked;

func _on_side_grab_triggered() -> void:
	if !is_active || is_locked:
		return;
	emit_signal("sidedeck_card", card_data);

func _on_delete_button_triggered() -> void:
	if !is_active || is_locked:
		return;
	emit_signal("alter_copies", -1, card_data);

func _on_add_copy_triggered() -> void:
	if copies == max_copies || !is_active || is_locked:
		return;
	emit_signal("alter_copies", copies + 1, card_data);

func _on_take_copy_triggered() -> void:
	if !is_active || is_locked:
		return;
	emit_signal("alter_copies", max(0, copies - 1), card_data);
