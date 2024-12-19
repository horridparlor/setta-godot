extends GlowNode
class_name DecklistSlip

signal alter_copies(new_amount, card_data);
signal sidedeck_card(card_data);
signal reference_card(card_data);
signal focus_on_attribute(card_data);

const BACKFRAME_PATH : String = "res://Prefabs/Nexus/DecksPage/DeckslipBackframe/";
const DECKSLIP_ATTRIBUTE_PATH : String = "res://Assets/Icons/Attributes/SmallSize/";
const LEVEL_FRAME_PATH : String = "res://Assets/Icons/LevelFrame/Small.png";
const DECK_MASTER_LEVEL_FRAME_PATH : String = "res://Assets/Icons/LevelFrame/SmallDeckMaster.png";

var card_data : CardData;
var copies : int;
var max_copies : int;
var is_active : bool;
var is_locked : bool;
var is_modulating_icons : bool;
var lock_increments : bool;

func init(new_data : CardData, copies : int) -> void:
	pass;
	
func set_copies(new_copies : int) -> int:
	return 0;

func toggle_active(value : bool = true) -> void:
	is_active = value;

func toggle_locked(value : bool = true) -> void:
	is_locked = value;
	update_count_icons();

func update_count_icons():
	pass;

func modulate_icons(level_modulation : float, attribute_modulation : float) -> void:
	pass;
