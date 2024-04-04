extends ExtraDeckStand

@onready var glow_node : GlowNode = $GlowNode;
@onready var button : TouchScreenButton = $Button;

func _ready() -> void:
	widget_type = GameplayEnums.WidgetType.EXTRA_DECK;

func control_glow(glow_state : GameplayEnums.GlowState, random : RandomNumberGenerator) -> void:
	glow_node.control_glow(glow_state, random);

func _on_button_pressed() -> void:
	emit_signal("pressed", widget_type);

func _on_button_released() -> void:
	emit_signal("released", widget_type);

func update_button() -> void:
	var x_width : int;
	var x_pos : int;
	match button_mode:
		GameplayEnums.ButtonMode.FULL:
			x_width = BUTTON_WIDTH_FULL;
			x_pos = BUTTON_X_POS_FULL;
		GameplayEnums.ButtonMode.PARTIAL:
			x_width = BUTTON_WIDTH_PARTIAL;
			x_pos = BUTTON_X_POS_PARTIAL;
	button.shape.size.x = x_width;
	button.position.x = x_pos;
			
