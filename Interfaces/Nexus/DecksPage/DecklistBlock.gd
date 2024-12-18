extends GlowNode
class_name DecklistBlock

signal trash();

const BLOCK_BACKFRAME_PATH : String = "res://Prefabs/Nexus/DecksPage/BlockBackframe/";
const LABEL_MESSAGE : String = "[center]%s [i](%s)[/i][/center]";
const COUNTLESS_LABEL_MESSAGE : String = "[center]%s[/center]";
const LABEL_POSITION_COUNTLESS : float = -18;
const LABEL_POSITION_WITH_COUNT : float = -23.5

var block : NexusEnums.DecklistBlocks;
var count : int;
var is_active : bool;

func init(new_block : NexusEnums.DecklistBlocks) -> void:
	pass;

func set_count(new_count : int) -> void:
	count = new_count;
	update_label();

func increment_count(increment : int) -> void:
	set_count(count + increment);

func update_label() -> void:
	pass;

func update_icons() -> void:
	pass;

func toggle_active(value : bool = true) -> void:
	is_active = value;
	update_icons();
