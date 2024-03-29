static func build_decks(gameplay : Gameplay):
	gameplay.player_1 = build_deck(GameplayEnums.OwningPlayer.PLAYER_1, gameplay);
	gameplay.player_2 = build_deck(GameplayEnums.OwningPlayer.PLAYER_2, gameplay);
	for player in gameplay.get_players():
		player.cards_in_deck.shuffle();

static func build_deck(owning_player : GameplayEnums.OwningPlayer, gameplay : Gameplay):
	return PlayerData.new(System.Decklist.DEFAULT, owning_player, gameplay.random);

static func draw_phase(gameplay : Gameplay):
	for player in gameplay.get_players():
		draw_to_hand_size(player, gameplay);

static func draw_to_hand_size(player : PlayerData, gameplay : Gameplay):
	while player.cards_in_hand.size() < player.HAND_SIZE:
		if player.cards_in_deck.is_empty():
			reshuffle_grave(player);
		if player.cards_in_deck.is_empty():
			break;
		draw_card(player, gameplay);

static func reshuffle_grave(player : PlayerData):
	for card in player.cards_in_grave.duplicate():
		return_to_deck_if_not_used(card, player);
	player.cards_in_deck.shuffle();

static func return_to_deck_if_not_used(card : CardData, player : PlayerData):
	if card.color in [CardEnums.CardColor.RED, CardEnums.CardColor.PURPLE] || !card.is_used:
		player.cards_in_grave.erase(card);
		player.cards_in_deck.append(card);

static func draw_card(player : PlayerData, gameplay : Gameplay):
	var top_index : int = 0;
	var deck : Array = player.cards_in_deck;
	var card : CardData = deck[top_index];
	deck.remove_at(top_index);
	player.cards_in_hand.append(card);
	card.zone = CardEnums.Zone.HAND;

static func play_card(card : GameplayCard, gameplay : Gameplay):
	var player : PlayerData = gameplay.turn_player;
	var card_data : CardData = card.card_data;
	player.cards_in_hand.erase(card_data);
	player.cards_on_field.append(card_data);
	player.mana_left -= card_data.cost;
	player.cards_played_this_turn += 1;
	card_data.zone = CardEnums.Zone.FIELD;

static func return_card_to_hand(card : GameplayCard, gameplay : Gameplay):
	var player : PlayerData = gameplay.turn_player;
	var card_data : CardData = card.card_data;
	player.cards_on_field.erase(card_data);
	player.cards_in_hand.append(card_data);
	player.mana_left += card_data.cost;
	player.cards_played_this_turn -= 1;
	card_data.zone = CardEnums.Zone.HAND;

static func can_be_played(card : GameplayCard, gameplay : Gameplay):
	var player : PlayerData = gameplay.turn_player;
	return true;
	
static func has_free_zone(gameplay : Gameplay):
	var player : PlayerData = gameplay.turn_player;
	return player.cards_on_field.size() < player.FIELD_SIZE;
