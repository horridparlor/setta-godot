extends Node
class_name PlayerData

var cards_in_backrow : Array = [];
var cards_in_deck : Array = [];
var cards_in_extra_deck : Array = [];
var cards_in_hand : Array = [];
var cards_in_grave : Array = [];
var cards_on_field : Array = [];
var cards_removed : Array = [];
var life : int = System.Rules.STARTING_LIFE;
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
	for card_id in source:
		for i in range(source[card_id]):
			card_data = CardData.new(card_id, init_data);
			get_container(zone).append(card_data);

func shuffle_deck() -> void:
	cards_in_deck.shuffle();

func draw_starting_hand() -> void:
	draw_cards(System.Rules.STARTING_HAND_SIZE);

func deck_empty() -> bool:
	return cards_in_deck.is_empty();

func draw_cards(amount : int) -> void:
	for i in range(amount):
		if deck_empty():
			break;
		draw();

func discard_cards(amount : int) -> void:
	for i in range(amount):
		if hand_empty():
			break;
		discard();

func discard() -> void:
	var card : CardData = get_rightmost_in_hand();
	move_card(card, CardEnums.Zone.HAND, CardEnums.Zone.GRAVE);

func get_rightmost_in_hand() -> CardData:
	return cards_in_hand[0];

func mill_cards(amount : int) -> void:
	for i in range(amount):
		if deck_empty():
			break;
		mill();

func mill() -> void:
	var card : CardData = get_top_of_deck();
	move_card(card, CardEnums.Zone.DECK, CardEnums.Zone.GRAVE);

func hand_empty() -> bool:
	return cards_in_hand.is_empty();

func count_hand() -> int:
	return cards_in_hand.size();

func count_deck() -> int:
	return cards_in_deck.size();

func commit_draw_phase() -> void:
	draw_cards(max(System.Rules.DRAW_PHASE_HAND_SIZE - count_hand(), 1));

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
	var tributes = get_tributes(card);
	return field_has_room(tributes) and has_enough_tributes(tributes);

func get_tributes(card : CardData) -> int:
	if !System.CardData.is_monster(card):
		return 0;
	var level : int = card.monster_data.level;
	if level < System.Rules.ONE_TRIBUTE_LEVEL:
		return 0;
	elif level < System.Rules.TWO_TRIBUTE_LEVEL:
		return 1;
	return 2;

func field_has_room(tributes : int) -> bool:
	return (cards_on_field.size() - tributes) < System.Rules.FIELD_SIZE;

func has_enough_tributes(tributes : int) -> bool:
	return cards_on_field.size() >= tributes;

func has_materials(card : CardData) -> bool:
	var found_materials : Array;
	for material_id in card.get_materials():
		if material_id == null:
			continue;
		if !has_material(material_id, found_materials):
			return false;
	return true;

func has_material(material_id : int, found_materials : Array) -> bool:
	var card : CardData;
	for c in cards_on_field:
		card = c;
		if card.face == CardEnums.Face.DOWN:
			continue;
		if card.card_id == material_id and card.instance_id not in found_materials:
			found_materials.append(card.instance_id);
			return true;
	return false;

func deal(amount : int) -> void:
	life -= amount;

func gain(amount : int) -> void:
	life += amount;
