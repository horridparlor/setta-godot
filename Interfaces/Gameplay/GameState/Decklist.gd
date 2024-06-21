extends Node
class_name Decklist

var main_deck : Dictionary;
var extra_deck : Dictionary;

func _init(
	main_deck_ : Dictionary,
	extra_deck_ : Dictionary
):
	main_deck = main_deck_;
	extra_deck = extra_deck_;

func get_cardlist() -> Dictionary:
	return {
		CardEnums.DeckType.MAIN: main_deck,
		CardEnums.DeckType.EXTRA: extra_deck	
	};
