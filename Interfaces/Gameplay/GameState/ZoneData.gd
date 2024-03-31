extends Node
class_name ZoneData

var zone : CardEnums.Zone;
var owning_player : GameplayEnums.OwningPlayer;

func _init(
	zone_ : CardEnums.Zone,
	owning_player_ : GameplayEnums.OwningPlayer,
):
	zone = zone_;
	owning_player = owning_player_;
