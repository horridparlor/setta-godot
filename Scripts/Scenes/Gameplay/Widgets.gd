static func fill_card_stands(
	owning_player : GameplayEnums.OwningPlayer,
	init_data : CardInitData,
	gameplay : Gameplay
) -> void:
	match owning_player:
		GameplayEnums.OwningPlayer.YOU:
			fill_your_stands(init_data, gameplay);
		GameplayEnums.OwningPlayer.OPPONENT:
			fill_opponents_stands(init_data, gameplay);

static func fill_your_stands(init_data : CardInitData, gameplay : Gameplay) -> void:
	fill_stands([
		gameplay.extra_deck_stand	
	], init_data, gameplay);
	
static func fill_opponents_stands(init_data : CardInitData, gameplay : Gameplay) -> void:
	fill_stands([
	], init_data, gameplay);
	
static func fill_stands(stands : Array, init_data : CardInitData, gameplay : Gameplay) -> void:
	var stand : CardStand;
	var card : GameplayCard;
	for s in stands:
		stand = s;
		card = stand.set_showcase_card(init_data);
		gameplay.cards[card.card_data.instance_id] = card;

static func control_showcase_glow(
	showcase : CardStand,
	glow_state : GameplayEnums.GlowState,
	gameplay : Gameplay
) -> void:
	showcase.control_glow(glow_state, gameplay.random);

static func get_showcases(gameplay : Gameplay) -> Array:
	return [
		gameplay.extra_deck_stand
	];

static func control_showcases_glow(glow_state : GameplayEnums.GlowState, gameplay : Gameplay) -> void:
	for showcase in get_showcases(gameplay):
		control_showcase_glow(showcase, glow_state, gameplay);
