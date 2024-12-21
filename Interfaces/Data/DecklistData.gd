extends Node
class_name DecklistData

var decklist_id : int;
var decklist_name : String;
var is_valid : bool;
var cards : Array;

var is_active : bool;
var has_unsaved_changes : bool;

func _init(id_ : int = 0, name_ : String = "", is_valid_ : bool = false, cards_ : Array = []):
	decklist_id = id_;
	decklist_name = name_;
	is_valid = is_valid_;
	cards = cards_;
	is_active = true;

func eat_cards(decklist_form : DecklistForm) -> void:
	var block : NexusEnums.DecklistBlock;
	var collections : Dictionary = decklist_form.get_collections();
	var card : CardData;
	var old_cards_json : String = JSON.stringify(get_cards_json());
	erase_cards();
	for b in collections:
		block = b;
		for c in collections[block].values():
			card = c;
			cards.append(CardInDecklist.new(card.errata_of_id, decklist_form.get_copies(card), block));
	if JSON.stringify(get_cards_json()) != old_cards_json:
		has_unsaved_changes = true;
	if decklist_name.is_empty():
		eat_name(decklist_form);

func eat_name(decklist_form : DecklistForm) -> void:
	var deck_master : CardData = decklist_form.get_deck_master();
	decklist_name = "%s (%s)" % [deck_master.normalized_name if deck_master else "My Deck", System.String_.get_time()];

func erase_cards() -> void:
	var card : CardInDecklist;
	for c in cards:
		card = c;
		card.queue_free();
	cards = [];

func eat_json(json_data : Dictionary) -> void:
	decklist_id = json_data.decklistId;
	decklist_name = json_data.name;
	is_valid = json_data.isValid;
	eat_cards_json(json_data);

func eat_cards_json(json_data : Dictionary) -> void:
	cards = [];
	for json in json_data.cards:
		cards.append(CardInDecklist.new(int(json.cardId), int(json.copies), System.DecklistBlock.to_enum(json.deckBlock)));

func get_json() -> Dictionary:
	return {
		"decklistId": decklist_id,
		"name": decklist_name,
		"isValid": is_valid,
		"cards": get_cards_json()
	}

func get_cards_json() -> Array:
	var source : Array;
	var card : CardInDecklist;
	for c in cards:
		card = c;
		source.append(card.get_json());
	return source;

func upload(parent : Node) -> void:
	if !is_active || !has_unsaved_changes:
		return;
	toggle_active(false);
	System.Server.request(RequestEnums.Operation.PUT_DECKLIST if decklist_id \
		else RequestEnums.Operation.POST_DECKLIST, \
		get_json(), parent);

func eat_posted(response : Dictionary) -> void:
	decklist_id = response.decklistId;
	is_valid = response.isValid;
	on_save_success();

func eat_put(response : Dictionary) -> void:
	is_valid = response.isValid;
	on_save_success();

func on_save_success() -> void:
	toggle_active();
	has_unsaved_changes = false;

func toggle_active(value : bool = true) -> void:
	is_active = value;

func is_new_empty() -> bool:
	return decklist_id == 0 and cards.is_empty();
