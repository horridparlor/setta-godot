extends Node2D
class_name DecklistForm

signal request_toggle_card(card_data);
signal deckmaster_counts_changed();

const DECKLIST_SLIP_PATH : String = "res://Prefabs/Nexus/DecksPage/DecklistSlip.tscn";
const SLIP_STARTING_POSITION : Vector2 = Vector2(0, 100);
const SLIP_MARGIN : Vector2 = Vector2(0, 100);
const BLOCK_MARGIN : Vector2 = Vector2(0, 110);

const MODULATION_SPEED : float = 0.3;
const MODULATION_WAIT : float = 10.5;

var deckmaster_cards : Dictionary;
var monster_cards : Dictionary;
var spell_cards : Dictionary;
var trap_cards : Dictionary;
var extra_cards : Dictionary;
var side_cards : Dictionary;
var card_counts : Dictionary;
var collection_counts : Dictionary = get_default_collection_counts();
var slips : Dictionary;
var min_y : float;
var active_blocks : int;
var is_active : bool;
var is_locked : bool;

var modulation_charge : float;
var is_modulating_icons : bool;
var has_slips_to_modulate : bool;
var is_modulating_in_level : bool;
var is_modulating_in_attribute : bool;
var count_of_monsters : int;

func get_default_collection_counts() -> Dictionary:
	var counts : Dictionary;
	for block in NexusEnums.DecklistBlocks.values():
		counts[block] = 0;
	return counts;

func toggle_card(card_data : CardData, do_reorder : bool) -> void:
	pass;

func update_min_y() -> void:
	pass;

func update_blocks() -> void:
	pass;

func reorder_slips() -> void:
	var current_position : Vector2 = SLIP_STARTING_POSITION;
	for slip in get_sorted_slips():
		slip.position = current_position;
		current_position += SLIP_MARGIN;
	update_blocks();
	update_min_y();
	
func sort_slips(slip_a : DecklistSlip, slip_b : DecklistSlip) -> int:
	return System.CardData.sort_by_card_type(slip_a.card_data, slip_b.card_data);

func get_sorted_slips() -> Array:
	var sorted_slips : Array = slips.values();
	sorted_slips.sort_custom(sort_slips);
	return sorted_slips;

func update_blocks_active() -> void:
	pass;

func toggle_active(value : bool = true) -> void:
	is_active = value;
	update_blocks_active();

func toggle_locked(value : bool = true) -> void:
	var slip : DecklistSlip;
	is_locked = value;
	for s in slips.values():
		slip = s;
		slip.toggle_locked(is_locked);
		slip.toggle_active(!is_locked);

func concat_non_backrow_collections() -> Array:
	return deckmaster_cards.values() + monster_cards.values() + extra_cards.values() + side_cards.values();
