extends Node2D
class_name DecklistForm

signal request_toggle_card(card_data);

const DECKLIST_SLIP_PATH : String = "res://Prefabs/Nexus/DecksPage/DecklistSlip.tscn";
const SLIP_STARTING_POSITION : Vector2 = Vector2(0, 100);
const SLIP_MARGIN : Vector2 = Vector2(0, 100);

var monster_cards : Dictionary;
var spell_cards : Dictionary;
var trap_cards : Dictionary;
var extra_cards : Dictionary;
var side_cards : Dictionary;
var card_counts : Dictionary;
var slips : Dictionary;
var min_y : float;

func toggle_card(card_data : CardData) -> void:
	pass; 
	
func reorder_slips() -> void:
	var current_position : Vector2 = SLIP_STARTING_POSITION;
	for slip in slips.values():
		slip.position = current_position;
		current_position += SLIP_MARGIN;
