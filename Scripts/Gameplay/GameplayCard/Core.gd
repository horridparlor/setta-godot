extends Node

static func initialize(card : GameplayCard) -> void:
	update_visuals(card);
	activate_animations(card);

static func update_visuals(card : GameplayCard) -> void:
	var card_data : CardData = card.card_data;
	card.Fragments.update_artwork(card);
	card.name_label.text = System.CardData.get_card_name(card_data);
	card.effect_label.text = card_data.effect_text;
	card.Fragments.update_monster_visuals(card);

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
