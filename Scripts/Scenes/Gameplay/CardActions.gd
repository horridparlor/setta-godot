static func card_action(action : CardEnums.CardAction, card : GameplayCard, gameplay : Gameplay) -> void:
	gameplay.Focuser.unfocus_card(card, gameplay);
	match action:
		CardEnums.CardAction.SET:
			set_card(card, gameplay);
		CardEnums.CardAction.SUMMON:
			summon_card(card, gameplay);

static func summon_card(card : GameplayCard, gameplay : Gameplay) -> void:
	gameplay.field.push_card(card, gameplay);

static func set_card(card : GameplayCard, gameplay : Gameplay) -> void:
	card.card_data.set_card();
	gameplay.field.push_card(card, gameplay);
