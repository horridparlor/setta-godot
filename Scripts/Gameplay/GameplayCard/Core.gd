extends Node

static func initialize(card : GameplayCard) -> void:
	card.Fragments.update_visuals(card);
	activate_animations(card);

static func activate_animations(card : GameplayCard) -> void:
	if card.glow_state == GameplayEnums.GlowState.GLOW:
		card.glow_node.glow(card.random);
	else:
		card.glow_node.shutter(card.random);

static func control_glow(
	glow_state : GameplayEnums.GlowState,
	card : GameplayCard
) -> void:
	card.glow_state = glow_state;
	activate_animations(card);
