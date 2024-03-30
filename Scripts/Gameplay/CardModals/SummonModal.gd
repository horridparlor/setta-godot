extends CardModal

func _ready() -> void:
	options = 2;

func _on_summon_pressed() -> void:
	emit_signal("card_action", CardEnums.CardAction.SUMMON);

func _on_set_pressed() -> void:
	emit_signal("card_action", CardEnums.CardAction.SET);
