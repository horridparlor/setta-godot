extends DecklistSlip

@onready var name_label : RichTextLabel = $NameLabel;
@onready var copy_bars : CopyBars = $CopyCounter/CopyBars;
@onready var backframe_layer : Node2D = $BackFrameLayer;
@onready var attribute_sprite : Sprite2D = $AttributeSprite;

func init(new_data : CardData) -> void:
	card_data = new_data;
	name_label.text = card_data.normalized_name;
	max_copies = System.CardData.get_max_copies(card_data);
	set_copies(max_copies);
	set_backframe();
	set_attribute();

func set_backframe() -> void:
	System.Instance.load_child(BACKFRAME_PATH + System.CardData.get_middle_frame_name(card_data) + SystemEnums.get_node_extension(), backframe_layer);

func set_attribute() -> void:
	var attribute_name : String = System.CardData.get_attribute_name(card_data);
	attribute_sprite.texture = load(DECKSLIP_ATTRIBUTE_PATH + attribute_name + SystemEnums.get_image_extension());

func _on_delete_button_pressed() -> void:
	emit_signal("alter_copies", -1, card_data);

func set_copies(new_copies : int) -> void:
	copies = new_copies;
	copy_bars.set_bars(copies, max_copies, card_data.is_ace);

func _on_add_copy_pressed() -> void:
	if copies == max_copies:
		return;
	emit_signal("alter_copies", copies + 1, card_data);

func _on_take_copy_pressed() -> void:
	emit_signal("alter_copies", max(0, copies - 1), card_data);

func _on_side_grab_pressed() -> void:
	emit_signal("alter_copies", 0, card_data);
