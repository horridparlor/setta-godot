extends Node
class_name CardInitData

var random : RandomNumberGenerator;
var sleeve : CardEnums.CardSleeve;
var owning_player : GameplayEnums.OwningPlayer;

func _init(
	owning_player_ : GameplayEnums.OwningPlayer,
	random_ : RandomNumberGenerator,
	sleeve_ : CardEnums.CardSleeve
):
	owning_player = owning_player_;
	random = random_;
	sleeve = sleeve_;
