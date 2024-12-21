extends Node2D
class_name DecklistForm

signal request_toggle_card(card_data);
signal deckmaster_counts_changed();
signal reference_card(card_data);
signal toast(message, theme);

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
var main_deck_counts : Dictionary;
var side_deck_counts : Dictionary;
var collection_counts : Dictionary = get_default_collection_counts();
var main_deck_slips : Dictionary;
var side_deck_slips : Dictionary;
var min_y : float;
var active_blocks : int;
var is_active : bool;
var is_locked : bool;
var aces : Dictionary = get_default_aces();

var modulation_charge : float;
var is_modulating_icons : bool;
var has_slips_to_modulate : bool;
var is_modulating_in_level : bool;
var is_modulating_in_attribute : bool;
var count_of_monsters : int;
var referenced_card : CardData;

func get_collections() -> Dictionary:
	return {
		NexusEnums.DecklistBlock.DECK_MASTER: deckmaster_cards,
		NexusEnums.DecklistBlock.MONSTER: monster_cards,
		NexusEnums.DecklistBlock.SPELL: spell_cards,
		NexusEnums.DecklistBlock.TRAP: trap_cards,
		NexusEnums.DecklistBlock.EXTRA: extra_cards,
		NexusEnums.DecklistBlock.SIDE: side_cards,
	};

func get_all_cards() -> Array:
	var all_cards : Array;
	for collection in get_collections().values():
		all_cards += collection.values();
	return all_cards;

func has_competing_ace(card_data : CardData, treat_as_main_deck_card : bool = false) -> bool:
	return card_data.is_ace && aces[System.CardData.get_ace_gategory(card_data, treat_as_main_deck_card)];

func toggle_ace(card_data : CardData, value : bool = true) -> void:
	var ace_category : CardEnums.AceCategory = System.CardData.get_ace_gategory(card_data);
	if ace_category == CardEnums.AceCategory.NONE:
		return;
	aces[ace_category] = value;

func count_main_deck() -> int:
	return collection_counts[NexusEnums.DecklistBlock.MONSTER] + \
		collection_counts[NexusEnums.DecklistBlock.SPELL] + \
		collection_counts[NexusEnums.DecklistBlock.TRAP];

func get_block_enum_for_card(card_data : CardData) -> NexusEnums.DecklistBlock:
	return NexusEnums.DecklistBlock.MONSTER;

func get_max_copies_fit(card_data : CardData) -> int:
	return min(card_data.max_copies, get_deck_room_for_card(card_data));

func get_room_for_non_ace_card(card_data : CardData) -> int:
	match get_block_enum_for_card(card_data):
		NexusEnums.DecklistBlock.DECK_MASTER:
			return 1;
		NexusEnums.DecklistBlock.EXTRA:
			return System.Rules.EXTRA_DECK_SIZE - count_extra_deck();
		NexusEnums.DecklistBlock.SIDE:
			return System.Rules.SIDE_DECK_SIZE - count_side_deck();
	return System.Rules.MAIN_DECK_SIZE - count_main_deck();

func get_deck_room_for_card(card_data : CardData) -> int:
	var room : int = get_room_for_non_ace_card(card_data);
	if card_data.is_ace:
		return min(room, 0 if has_competing_ace(card_data) else 1);
	return room;

func count_extra_deck() -> int:
	return collection_counts[NexusEnums.DecklistBlock.EXTRA];

func count_side_deck() -> int:
	return collection_counts[NexusEnums.DecklistBlock.SIDE];

func main_deck_full() -> bool:
	return count_main_deck() >= System.Rules.MAIN_DECK_SIZE;

func extra_deck_full() -> bool:
	return count_extra_deck() >= System.Rules.EXTRA_DECK_SIZE;

func side_deck_full() -> bool:
	return count_side_deck() >= System.Rules.SIDE_DECK_SIZE;

func can_add_to_main_deck(card_data : CardData) -> bool:
	return !(main_deck_full() if System.CardData.is_main_deck(card_data) else side_deck_full()) && !has_competing_ace(card_data, true);

func can_add_to_side_deck(card_data : CardData) -> bool:
	return !side_deck_full();

func get_default_collection_counts() -> Dictionary:
	var counts : Dictionary;
	for block in NexusEnums.DecklistBlock.values():
		counts[block] = 0;
	return counts;

func get_default_aces() -> Dictionary:
	var aces : Dictionary;
	for category in CardEnums.AceCategory.values():
		aces[category] = false;
	return aces;

func toggle_card(card_data : CardData, do_reorder : bool, for_all_decks : bool) -> void:
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

func get_slips() -> Array:
	return main_deck_slips.values() + side_deck_slips.values();

func get_slip_collection(card_data : CardData) -> Dictionary:
	return main_deck_slips if System.CardData.in_main_deck(card_data) else side_deck_slips;

func get_copies_collection(card_data : CardData) -> Dictionary:
	return main_deck_counts if System.CardData.in_main_deck(card_data) else side_deck_counts;

func get_copies(card_data : CardData) -> int:
	var counts : Dictionary = get_copies_collection(card_data);
	return counts[card_data.card_id] if counts.has(card_data.card_id) else 0;

func get_slip(card_data : CardData) -> DecklistSlip:
	return get_slip_collection(card_data)[card_data.card_id];

func get_slips_for_card(card_data : CardData) -> Array:
	var slips : Array;
	if main_deck_counts.has(card_data.card_id):
		slips.append(main_deck_slips[card_data.card_id]);
	if side_deck_counts.has(card_data.card_id):
		slips.append(side_deck_slips[card_data.card_id]);
	return slips;

func put_slip(card_data : CardData, slip : DecklistSlip) -> void:
	get_slip_collection(card_data)[card_data.card_id] = slip;

func erase_slip(card_data : CardData) -> void:
	get_slip_collection(card_data).erase(card_data.card_id);

func get_sorted_slips() -> Array:
	var sorted_slips : Array = get_slips();
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
	for s in get_slips():
		slip = s;
		slip.toggle_locked(is_locked);
		slip.toggle_active(!is_locked);

func concat_non_backrow_collections() -> Array:
	return deckmaster_cards.values() + monster_cards.values() + extra_cards.values() + side_cards.values();

func erase_count(card_data : CardData) -> void:
	get_copies_collection(card_data).erase(card_data.card_id);

func card_in_any_deck(card_data : CardData) -> bool:
	return main_deck_slips.has(card_data.card_id) || side_deck_slips.has(card_data.card_id);

func in_both_decks(card_data : CardData) -> bool:
	return main_deck_slips.has(card_data.card_id) && side_deck_slips.has(card_data.card_id);

func get_deck_master() -> CardData:
	for card in deckmaster_cards.values():
		if main_deck_counts[card.card_id] > 0:
			return card;
	return null;

func delete_all_slips() -> void:
	var slip : DecklistSlip;
	for s in get_slips():
		slip = s;
		slip.queue_free();
	main_deck_slips = {};
	side_deck_slips = {};

func delete_all_cards() -> void:
	deckmaster_cards = {};
	monster_cards = {};
	spell_cards = {};
	trap_cards = {};
	extra_cards = {};
	side_cards = {};
	
	collection_counts = get_default_collection_counts();
	aces = get_default_aces();
	
	main_deck_counts = {};
	side_deck_counts = {};

func spawn_card(card_data : CardData, copies : int = 0) -> void:
	pass;
	
func eat_decklist(decklist : DecklistData) -> void:
	var card : CardInDecklist;
	var card_data : CardData;
	delete_all_slips();
	delete_all_cards();
	for c in decklist.cards:
		card = c;
		card_data = System.CardData.from_id(card.card_id);
		if System.DecklistBlock.is_side_deck(card.block):
			card_data.move_to_side_deck();
		spawn_card(card_data, card.copies);
	for slip in get_slips():
		slip.toggle_locked();
	reorder_slips();
	toggle_active(false);
	
