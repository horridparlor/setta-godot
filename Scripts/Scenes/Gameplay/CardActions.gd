static func card_action(action : CardEnums.CardAction, card : GameplayCard, gameplay : Gameplay) -> void:
	gameplay.Focuser.unfocus_card(card, gameplay);
	match action:
		CardEnums.CardAction.SET:
			play_card(GameplayEnums.PlayType.SET, card, gameplay);
		CardEnums.CardAction.SUMMON:
			play_card(GameplayEnums.PlayType.SUMMON, card, gameplay);
		CardEnums.CardAction.TRIBUTE:
			tribute_card(card, gameplay);

static func summon_card(card : GameplayCard, gameplay : Gameplay) -> void:
	gameplay.field.push_card(card, gameplay);

static func set_card(card : GameplayCard, gameplay : Gameplay) -> void:
	card.card_data.set_card();
	gameplay.field.push_card(card, gameplay);

static func play_card(
	play_type : GameplayEnums.PlayType, card : GameplayCard, gameplay : Gameplay
) -> void:
	var tributes = card.Rules.get_tributes(card, gameplay);
	if tributes:
		tribute_cards(tributes, play_type, card, gameplay);
		return;
	commit_play(play_type, card, gameplay);

static func commit_play(
	play_type : GameplayEnums.PlayType, card : GameplayCard, gameplay : Gameplay
):
	gameplay.release_modal(card);
	match play_type:
		GameplayEnums.PlayType.SET:
			set_card(card, gameplay);
		GameplayEnums.PlayType.SUMMON:
			summon_card(card, gameplay);

static func tribute_cards(
	tributes : int, play_type : GameplayEnums.PlayType,
	card : GameplayCard, gameplay : Gameplay
) -> void:
	gameplay.card_to_be_played = card;
	gameplay.actions_left = tributes;
	gameplay.play_type = play_type;
	gameplay.Selection.set_selection(GameplayEnums.SelectionType.TRIBUTE, gameplay);

static func tribute_card(
	card : GameplayCard, gameplay : Gameplay
):
	gameplay.grave.push_card(card, gameplay);
	card.despawn(gameplay);
	gameplay.actions_left -= 1;
	if gameplay.actions_left == 0:
		commit_play(gameplay.play_type, gameplay.card_to_be_played, gameplay);
