extends Node2D
class_name CardScene

var cards : Dictionary;
var focused_card : GameplayCard;
var card_to_be_played : GameplayCard;
var selection_type : GameplayEnums.SelectionType = GameplayEnums.SelectionType.NONE;

func is_selecting() -> bool:
	return selection_type != GameplayEnums.SelectionType.NONE;
