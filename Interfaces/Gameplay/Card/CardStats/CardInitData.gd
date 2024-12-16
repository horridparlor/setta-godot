extends Node
class_name CardInitData

var sleeve : CardEnums.CardSleeve;
var owning_player : GameplayEnums.OwningPlayer;

func _init(
	owning_player_ : GameplayEnums.OwningPlayer,
	sleeve_ : CardEnums.CardSleeve
):
	owning_player = owning_player_;
	sleeve = sleeve_;
