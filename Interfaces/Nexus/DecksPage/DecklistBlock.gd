extends GlowNode
class_name DecklistBlock

signal trash(block);
signal collapse(block, value);

const BLOCK_BACKFRAME_PATH : String = "res://Prefabs/Nexus/DecksPage/BlockBackframe/";
const LABEL_MESSAGE : String = "[center]%s [i](%s)[/i][/center]";
const COUNTLESS_LABEL_MESSAGE : String = "[center]%s[/center]";
const ONLY_COUNT_LABEL_MESSAGE : String = "[center]%s[i] / 60[/i][/center]";
const FULL_LABEL_TEXT : String = "[center]Full[/center]";
const LABEL_POSITION_COUNTLESS : float = -18;
const LABEL_POSITION_WITH_COUNT : float = -23.5
const BLACK_DOWN_ARROW_PATH : String = "res://Assets/Icons/Common/down/DownArrowBlack.png";
const WHITE_DOWN_ARROW_PATH : String = "res://Assets/Icons/Common/down/DownArrowWhite.png";

var block : NexusEnums.DecklistBlocks;
var count : int;
var is_active : bool;
var is_collapsed : bool;

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

func update_down_arrow() -> void:
	pass;

func toggle_collapsed(value : bool = true) -> void:
	is_collapsed = value;
	update_down_arrow();
