extends Node
class_name CardInDecklist

var card_id : int;
var copies : int;
var block : NexusEnums.DecklistBlock;

func _init(card_id_ : int, copies_ : int, block_ : NexusEnums.DecklistBlock):
	card_id = card_id_;
	copies = copies_;
	block = block_;

func get_json() -> Dictionary:
	return {
		'cardId': card_id,
		'copies': copies,
		'deckBlock': System.DecklistBlock.to_json(block)
	};
