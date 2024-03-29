static func start_turn(gameplay : Gameplay) -> void:
	gameplay.CardManager.draw_phase(gameplay);
	start_main_phase(gameplay);

static func start_main_phase(gameplay : Gameplay) -> void:
	gameplay.turn_player = gameplay.other_player();
	gameplay.turn_phase = GameplayEnums.TurnPhase.MAIN_PHASE;
	rotate_turn_player(gameplay);

static func instance_card(card_data : CardData, zone : Zone, gameplay : Gameplay) -> void:
	var card : GameplayCard = System.Instance.load_child(gameplay.CARD_PATH, zone);
	card.pressed.connect(gameplay._on_card_clicked);
	card.released.connect(gameplay._on_card_released);
	card.update_playstate.connect(gameplay._on_update_card_playstate);
	card.card_data = card_data;
	zone.push_card(card, gameplay);
	card.Core.initialize(card, gameplay);
	gameplay.cards.append(card);

static func rotate_turn_player(gameplay : Gameplay) -> void:
	var turn_player : PlayerData = gameplay.turn_player;
	var owning_player : GameplayEnums.OwningPlayer = turn_player.owning_player;
	gameplay.hand.turn_to_player(owning_player);

static func pass_turn(gameplay : Gameplay) -> void:
	if gameplay.focused_card != null:
		return;
	for c in gameplay.cards:
		var card : GameplayCard = c;
		card.can_return_to_hand = false;

static func check_if_start_final_phase(gameplay : Gameplay) -> bool:
	var card_was_played : bool = gameplay.turn_player.cards_played_this_turn > 0;
	for p in gameplay.get_players():
		var player : PlayerData = p;
		player.cards_played_this_turn = 0;
	return !card_was_played;

static func end_round(gameplay : Gameplay) -> void:
	start_turn(gameplay);
