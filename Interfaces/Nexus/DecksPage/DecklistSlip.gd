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

func init(new_data : CardData) -> void:
	pass;
	
func set_copies(new_copies : int) -> void:
	pass;
