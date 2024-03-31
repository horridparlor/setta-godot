extends Node
class_name Decklist

const PREMADE_PREFIX : String = "res://Data/DeckLists/";
const SUBFIX : String = ".gd";

var decklist_type : GameplayEnums.DecklistType;
var path : String;

func _init(
	decklist_type_ : GameplayEnums.DecklistType,
	path_ : String
):
	decklist_type = decklist_type_;
	path = path_;

func get_cardlist():
	return load(PREMADE_PREFIX + path + SUBFIX).out();
