extends GameplayModalZone

func _ready():
	zone = CardEnums.Zone.MODAL;
	zone_height = MODAL_HEIGHT;
	zone_width = MODAL_WIDTH;
	zone_type = GameplayEnums.ZoneType.SCROLL;
