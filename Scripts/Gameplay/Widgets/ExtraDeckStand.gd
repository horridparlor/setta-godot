extends CardStand

@onready var glow_node : GlowNode = $GlowNode;

func control_glow(glow_state : GameplayEnums.GlowState, random : RandomNumberGenerator) -> void:
	glow_node.control_glow(glow_state, random);
		
