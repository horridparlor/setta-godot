static func load_sleeve(sleeve : CardEnums.CardSleeve, card : GameplayCard) -> void:
	card.card_sleeve = System.Instance.load_child(
		get_sleeve_path(sleeve, card),
		card.sleeve_layer
	);

static func get_sleeve_path(sleeve : CardEnums.CardSleeve, card : GameplayCard) -> String:
	return card.SLEEVE_LOAD_PREFIX + CardEnums.CardSleevePath[sleeve] + \
	SystemEnums.get_node_extension();

static func show_sleeve(card : GameplayCard) -> void:
	render_sleeve(card);
	set_sleeve_opacity(card);

static func set_sleeve_opacity(card : GameplayCard) -> void:
	if card.is_showcase():
		return;
	card.card_sleeve.activate_animations(card.random, GlowNode.GlowType.OPACITY);

static func render_sleeve(card : GameplayCard) -> void:
	if card.card_sleeve:
		return;
	card.Sleeves.load_sleeve(card.card_data.sleeve, card);

static func hide_sleeve(card : GameplayCard) -> void:
	if !card.card_sleeve:
		return;
	card.card_sleeve.queue_free();
	card.card_sleeve = null;

static func set_face(card : GameplayCard) -> void:
	match card.card_data.face:
		CardEnums.Face.DOWN:
			if card.focus_state == GameplayEnums.FocusState.INTERACT:
				hide_sleeve(card);
			else:
				show_sleeve(card);
		CardEnums.Face.UP:
			hide_sleeve(card);
