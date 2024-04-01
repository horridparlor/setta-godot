extends CardStand

@onready var glow_node : GlowNode = $GlowNode;

func _ready() -> void:
	widget_type = GameplayEnums.WidgetType.EXTRA_DECK;

func control_glow(glow_state : GameplayEnums.GlowState, random : RandomNumberGenerator) -> void:
	glow_node.control_glow(glow_state, random);

func _on_button_pressed() -> void:
	emit_signal("pressed", widget_type);

func _on_button_released() -> void:
	emit_signal("released", widget_type);
