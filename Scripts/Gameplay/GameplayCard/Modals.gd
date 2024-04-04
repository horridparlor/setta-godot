static func examine(card : GameplayCard, gameplay : Gameplay) -> void:
	close_modal(card, gameplay);
	render_modal(gameplay.active_modal, card, gameplay);

static func render_modal(
	modal_type : GameplayEnums.CardModalType, card : GameplayCard, gameplay : Gameplay
) -> void:
	var modal_path : String = get_modal_path(modal_type, card);
	print(modal_path, " ", modal_type);
	card.modal = System.Instance.load_child(modal_path, card.modal_layer);
	card.modal.card_action.connect(card._on_modal_action);
	card.modal.position.y -= card.MODAL_MIN_HEIGHT + card.MODAL_OPTION_HEIGHT * card.modal.options;
	shutter_other_cards(card, gameplay);

static func get_modal_path(
	modal_type : GameplayEnums.CardModalType, card : GameplayCard
) -> String:
	match modal_type:
		GameplayEnums.CardModalType.SUMMON:
			return card.SUMMON_MODAL_PATH;
		GameplayEnums.CardModalType.TRIBUTE:
			return card.TRIBUTE_MODAL_PATH;
	return card.SUMMON_MODAL_PATH;

static func interact(card : GameplayCard, gameplay : Gameplay) -> void:
	close_modal(card, gameplay);
	shutter_other_cards(card, gameplay);

static func glow_other_cards(card : GameplayCard, gameplay : Gameplay) -> void:
	control_others_glow(GameplayEnums.GlowState.GLOW, card, gameplay);

static func shutter_other_cards(card : GameplayCard, gameplay : Gameplay) -> void:
	control_others_glow(GameplayEnums.GlowState.SHUTTER, card, gameplay);

static func control_others_glow(
	glow_state : GameplayEnums.GlowState,
	card : GameplayCard, gameplay : Gameplay
) -> void:
	change_other_cards_glow(glow_state, card, gameplay);
	gameplay.Widgets.control_showcases_glow(glow_state, gameplay);

static func change_other_cards_glow(
	glow_state : GameplayEnums.GlowState,
	card : GameplayCard,
	gameplay : Gameplay
) -> void:
	var cards : Dictionary = gameplay.cards;
	for instance_id in cards:
		if instance_id != card.card_data.instance_id:
			var other_card : GameplayCard = cards[instance_id];
			other_card.Core.control_glow(GameplayEnums.GlowState.SHUTTER if \
				gameplay.active_widget != GameplayEnums.WidgetType.NONE and \
				other_card.card_data.zone != CardEnums.Zone.SHOWCASE and \
				(!other_card.zone or other_card.zone.zone != CardEnums.Zone.MODAL) \
				else glow_state, other_card, gameplay);

static func close_modal(card : GameplayCard, gameplay : Gameplay) -> void:
	if card.modal:
		card.modal.queue_free();
		card.modal = null;
	card.Core.activate_animations(card);
	glow_other_cards(card, gameplay);
