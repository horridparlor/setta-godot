extends Node
class_name PlayerData

const STARTING_LIFE : int = 8000;
const STARTING_HAND_SIZE : int = 4;
const DRAW_PHASE_HAND_SIZE : int = 5;
const FIELD_SIZE : int = 3;
const BACKROW_SIZE : int = 5;
const PENDULUM_SIZE : int = 2;

var cards_in_backrow : Array = [];
var cards_in_deck : Array = [];
var cards_in_extra_deck : Array = [];
var cards_in_hand : Array = [];
var cards_in_grave : Array = [];
var cards_on_field : Array = [];
var cards_removed : Array = [];
var life : int = STARTING_LIFE;
var owning_player : GameplayEnums.OwningPlayer;

func _init(
	decklist : Decklist,
	player : GameplayEnums.OwningPlayer,
	init_data : CardInitData,
):
	var cardlist : Dictionary = decklist.get_cardlist();
	owning_player = player;
	create_cards(init_data, cardlist[CardEnums.DeckType.MAIN], CardEnums.Zone.DECK);
	create_cards(init_data, cardlist[CardEnums.DeckType.EXTRA], CardEnums.Zone.EXTRA_DECK);
	shuffle_deck();
	draw_starting_hand();

func create_cards(init_data : CardInitData, source : Dictionary, zone : CardEnums.Zone):
	var card_data : CardData;
	for card in source:
		for i in range(source[card]):
			card_data = System.CardData.create(card, init_data, owning_player);
			get_container(zone).append(card_data);

func shuffle_deck() -> void:
	cards_in_deck.shuffle();

func draw_starting_hand() -> void:
	draw_cards(STARTING_HAND_SIZE);

func deck_empty() -> bool:
	return cards_in_deck.is_empty();

func draw_cards(amount : int) -> void:
	for i in range(amount):
		if deck_empty():
			break;
		draw();

func count_hand() -> int:
	return cards_in_hand.size();

func count_deck() -> int:
	return cards_in_deck.size();

func commit_draw_phase() -> void:
	draw_cards(max(DRAW_PHASE_HAND_SIZE - count_hand(), 1));

func get_top_of_deck() -> CardData:
	return cards_in_deck[cards_in_deck.size() - 1];

func draw() -> void:
	var card : CardData = get_top_of_deck();
	move_card(card, CardEnums.Zone.DECK, CardEnums.Zone.HAND);

func move_card(card : CardData, from_zone : CardEnums.Zone, to_zone : CardEnums.Zone):
	pull_card(card, from_zone);
	push_card(card, to_zone);

func get_container(zone : CardEnums.Zone) -> Array:
	match zone:
		CardEnums.Zone.BACKROW:
			return cards_in_backrow;
		CardEnums.Zone.DECK:
			return cards_in_deck;
		CardEnums.Zone.EXTRA_DECK:
			return cards_in_extra_deck;
		CardEnums.Zone.HAND:
			return cards_in_hand;
		CardEnums.Zone.GRAVE:
			return cards_in_grave;
		CardEnums.Zone.FIELD:
			return cards_on_field;
		CardEnums.Zone.REMOVED:
			return cards_removed;
	return [];

func pull_card(card : CardData, zone : CardEnums.Zone) -> void:
	get_container(zone).erase(card);

func push_card(card : CardData, zone : CardEnums.Zone) -> void:
	get_container(zone).append(card);
	card.zone = zone;

func can_play_card(card : CardData) -> bool:
	return cards_on_field.size() < FIELD_SIZE;
