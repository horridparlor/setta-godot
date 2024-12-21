extends Node
class_name DecklistData

var decklist_id : int;
var decklist_name : String;
var is_valid : bool;
var cards : Array;

func _init(id_ : int = 0, name_ : String = "", is_valid_ : bool = false, cards_ : Array = []):
	decklist_id = id_;
	decklist_name = name_;
	is_valid = is_valid_;
	cards = cards_;

func eat_cards(decklist_form : DecklistForm) -> void:
	var block : NexusEnums.DecklistBlock;
	var collections : Dictionary = decklist_form.get_collections();
	var card : CardData;
	erase_cards();
	for b in collections:
		block = b;
		for c in collections[block].values():
			card = c;
			cards.append(CardInDecklist.new(card.card_id, decklist_form.get_copies(card), block));
	if decklist_name.is_empty():
		eat_name(decklist_form);

func eat_name(decklist_form : DecklistForm) -> void:
	decklist_name = "%s (%s)" % [decklist_form.get_deck_master().normalized_name, System.String_.get_time()];

func erase_cards() -> void:
	var card : CardInDecklist;
	for c in cards:
		card = c;
		card.queue_free();
	cards = [];

func get_json() -> Dictionary:
	return {
		"decklistId": decklist_id,
		"name": decklist_name,
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
	System.Server.request(RequestEnums.Operation.PUT_DECKLIST if decklist_id \
		else RequestEnums.Operation.POST_DECKLIST, \
		get_json(), parent);
