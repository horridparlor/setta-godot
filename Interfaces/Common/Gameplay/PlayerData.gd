extends Node
class_name PlayerData

const STARTING_LIFE : int = 8000;
const STARTING_HAND : int = 4;
const HAND_SIZE : int = 5;
const FIELD_SIZE : int = 3;
const BACKROW_SIZE : int = 5;

var cards_in_deck : Array = [];
var cards_in_hand : Array = [];
var cards_in_grave : Array = [];
var cards_on_field : Array = [];
var cards_removed : Array = [];
var life : int = STARTING_LIFE;
var owning_player : GameplayEnums.OwningPlayer;

func _init(decklist : Decklist, player : GameplayEnums.OwningPlayer, random : RandomNumberGenerator):
	var cardlist : Dictionary = decklist.get_cardlist();
	var card_data : CardData;
	owning_player = player;
	for card in cardlist:
		for i in range(cardlist[card]):
			card_data = System.CardData.create(card, random, owning_player);
			cards_in_deck.append(card_data);
