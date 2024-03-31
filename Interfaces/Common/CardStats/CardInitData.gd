extends Node
class_name CardInitData

var random : RandomNumberGenerator;
var sleeve : CardEnums.CardSleeve;

func _init(
	random_ : RandomNumberGenerator,
	sleeve_ : CardEnums.CardSleeve
):
	random = random_;
	sleeve = sleeve_;
