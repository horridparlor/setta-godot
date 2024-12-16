extends Node

static func initialize(card : GameplayCard, card_scene : CardScene) -> void:
	update_visuals(card);
	control_glow(GameplayEnums.GlowState.GLOW, card, card_scene);

static func update_visuals(card : GameplayCard) -> void:
	card.Fragments.update_artwork(card);
	update_name(card);
	card.effect_label.text = card.card_data.effects_text;
	card.Fragments.update_monster_visuals(card);
	update_debug_tools(card);

static func update_debug_tools(card : GameplayCard) -> void:
	var card_debug_on : bool = System.debug_mode == SystemEnums.DebugMode.CARD_DEBUG;
	card.copiable_name.visible = card_debug_on;
	card.name_label.visible = !card_debug_on;

static func update_name(card : GameplayCard) -> void:
	if System.debug_mode == SystemEnums.DebugMode.CARD_DEBUG:
		card.copiable_name.text = str(card.card_data.instance_id);
	else:
		card.name_label.text = card.card_data.display_name;

static func activate_animations(card : GameplayCard) -> void:
	if card.glow_state == GameplayEnums.GlowState.GLOW:
		card.glow_node.glow();
	else:
		card.glow_node.shutter();

static func control_glow(
	glow_state : GameplayEnums.GlowState,
	card : GameplayCard,
	card_scene : CardScene
) -> void:
	if must_be_glowing(card, card_scene):
		glow_state = GameplayEnums.GlowState.GLOW;
	elif must_be_shuttered(card, card_scene):
		glow_state = GameplayEnums.GlowState.SHUTTER;
	card.glow_state = glow_state;
	activate_animations(card);

static func must_be_glowing(card : GameplayCard, card_scene : CardScene) -> bool:
	if card == card_scene.card_to_be_played or card == card_scene.focused_card:
		return true;
	return false;

static func must_be_shuttered(card : GameplayCard, card_scene : CardScene) -> bool:
	if !card.zone:
		return card_scene.selection_type != GameplayEnums.SelectionType.NONE;
	if card_scene.is_selecting():
		return !is_selectable(card, card_scene);
	match card.card_data.zone:
		CardEnums.Zone.HAND:
			return !card.Rules.can_be_played(card, card_scene);
		CardEnums.Zone.EXTRA_DECK:
			return !card.Rules.have_materials(card, card_scene);
	return false;

static func is_selectable(card : GameplayCard, gameplay : Gameplay) -> bool:
	match gameplay.selection_type:
		GameplayEnums.SelectionType.TRIBUTE:
			return card.card_data.zone == CardEnums.Zone.FIELD;
	return true;

static func set_initial_scale(zone : CardEnums.Zone, card : GameplayCard):
	card.scale = get_initial_scale(zone, card);

static func get_initial_scale(zone : CardEnums.Zone, card : GameplayCard) -> Vector2:
	match zone:
		CardEnums.Zone.MODAL:
			return card.BASE_SCALE_MODAL;
	return card.BASE_SCALE_HAND;
