extends CardModal

func _ready() -> void:
	options = 1;

func _on_tribute_pressed():
	emit_signal("card_action", CardEnums.CardAction.TRIBUTE);
