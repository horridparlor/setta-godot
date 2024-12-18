extends DecklistBlock

@onready var label : RichTextLabel = $Label;
@onready var frame_layer : Node2D = $FrameLayer;

func init(new_block : NexusEnums.DecklistBlocks) -> void:
	block = new_block;
	update_label();
	update_frame();

func get_block_name() -> String:
	return NexusEnums.DecklistBlockNames[block]

func update_label() -> void:
	var block_name : String = get_block_name();
	var is_countless : bool = block == NexusEnums.DecklistBlocks.DECK_MASTER;
	label.text = COUNTLESS_LABEL_MESSAGE % block_name \
		if is_countless \
		else LABEL_MESSAGE % [block_name, count];
	label.position.y = LABEL_POSITION_COUNTLESS if is_countless else LABEL_POSITION_WITH_COUNT;

func update_frame() -> void:
	System.Instance.load_child(BLOCK_BACKFRAME_PATH + System.String_.serialize(get_block_name()) + SystemEnums.get_node_extension(), frame_layer);
