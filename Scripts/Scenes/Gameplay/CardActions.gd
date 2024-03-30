static func card_action(action : CardEnums.CardAction, card : GameplayCard, gameplay : Gameplay) -> void:
	gameplay.Focuser.unfocus_card(card, gameplay);
	match action:
		CardEnums.CardAction.SUMMON:
			summon_card(card, gameplay);

static func summon_card(card : GameplayCard, gameplay : Gameplay) -> void:
	gameplay.field.push_card(card, gameplay);
