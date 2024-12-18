extends Node2D
class_name DecklistSlip

signal alter_copies(new_amount, card_data);
signal sidedeck_card(card_data);
signal reference_card(card_data);
signal focus_on_attribute(card_data);

const BACKFRAME_PATH : String = "res://Prefabs/Nexus/DecksPage/DeckslipBackframe/";
const DECKSLIP_ATTRIBUTE_PATH : String = "res://Assets/Icons/Attributes/SmallSize/";

var card_data : CardData;
var copies : int;
var max_copies : int;
var is_active : bool;
var is_locked : bool;

func init(new_data : CardData) -> void:
	pass;
	
func set_copies(new_copies : int) -> void:
	pass;

func toggle_active(value : bool = true) -> void:
	is_active = value;

func toggle_locked(value : bool = true) -> void:
	is_locked = value;
	update_count_icons();

func update_count_icons():
	pass;
