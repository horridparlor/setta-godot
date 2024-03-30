static func init_game_state(gameplay : Gameplay) -> void:
	gameplay.game_state = GameState.new(
		build_player(GameplayEnums.OwningPlayer.YOU, gameplay),
		build_player(GameplayEnums.OwningPlayer.OPPONENT, gameplay),
		gameplay.random
	);

static func build_player(owning_player : GameplayEnums.OwningPlayer, gameplay : Gameplay) -> PlayerData:
	return PlayerData.new(
		System.Decklist.premade(System.Decklist.Premade.DEFAULT),
		owning_player, gameplay.random
	);
