extends Node
class_name PlayerData

const STARTING_LIFE : int = 20;
const HAND_SIZE : int = 5;
const FIELD_SIZE : int = 4;
const DECK_LIST_PREFIX : String = "res://Data/DeckLists/";
const SUBFIX : String = ".gd";

var cards_in_deck : Array = [];
var cards_in_hand : Array = [];
var cards_in_grave : Array = [];
var cards_on_field : Array = [];
var life : int = STARTING_LIFE;
var mana_left : int;
var owning_player : GameplayEnums.OwningPlayer;

var cards_played_this_turn : int;
var is_charged : bool
var protections : Dictionary;

func _init(deck_name : String, player : GameplayEnums.OwningPlayer, random : RandomNumberGenerator):
	var deck_list : Dictionary = load(DECK_LIST_PREFIX + deck_name + SUBFIX).out();
	var card_data : CardData;
	owning_player = player;
	for card in deck_list:
		for i in range(deck_list[card]):
			card_data = System.CardData.create(card, random, owning_player);
			cards_in_deck.append(card_data);
