static func init_game_state(gameplay : Gameplay) -> void:
	gameplay.game_state = GameState.new(
		build_player(GameplayEnums.OwningPlayer.YOU, gameplay),
		build_player(GameplayEnums.OwningPlayer.OPPONENT, gameplay),
		gameplay.random
	);

static func build_player(owning_player : GameplayEnums.OwningPlayer, gameplay : Gameplay) -> PlayerData:
	var init_data : CardInitData = CardInitData.new(gameplay.random, CardEnums.CardSleeve.DEFAULT);
	gameplay.Widgets.fill_card_stands(owning_player, init_data, gameplay);
	return PlayerData.new(
		System.Decklist.premade(System.Decklist.Premade.DEFAULT),
		owning_player,
		init_data
	);

static func get_card_init_data(
	owning_player : GameplayEnums.OwningPlayer,
	gameplay : Gameplay
) -> CardInitData:
	return CardInitData.new(gameplay.random, CardEnums.CardSleeve.DEFAULT);
