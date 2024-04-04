static func get_tributes(card : GameplayCard, gameplay : Gameplay) -> int:
	var card_data : CardData = card.card_data;
	return gameplay.game_state.get_player(card_data.controlling_player).get_tributes(card_data);

static func can_be_played(card : GameplayCard, gameplay : Gameplay) -> bool:
	return gameplay.game_state.can_play_card(card.card_data, GameplayEnums.OwningPlayer.YOU);

static func have_materials(card : GameplayCard, gameplay : Gameplay) -> bool:
	return gameplay.game_state.has_materials(card.card_data, GameplayEnums.OwningPlayer.YOU);
