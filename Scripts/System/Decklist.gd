static func get_random(random : RandomNumberGenerator) -> Decklist:
	return Decklist.new(
		get_random_main_deck(random),
		get_random_extra_deck(random)
	);

static func get_random_main_deck(random : RandomNumberGenerator) -> Dictionary:
	return get_random_deck(
		PlayerData.MAIN_DECK_SIZE,
		System.main_deck_cards,
		random,
		PlayerData.MAIN_DECK_DUPLICATES
	);

static func get_random_extra_deck(random : RandomNumberGenerator) -> Dictionary:
	return get_random_deck(PlayerData.EXTRA_DECK_SIZE, System.extra_deck_cards, random);

static func get_random_deck(
	size : int, source : Dictionary, random : RandomNumberGenerator, duplicates : int = 1
) -> Dictionary:
	var deck : Dictionary;
	var card_id : int;
	var filled : int;
	var pool : Dictionary = source.duplicate();
	for i in range(size):
		card_id = System.Random.key(pool, random);
		if deck.has(card_id):
			deck[card_id] += 1;
		else:
			deck[card_id] = 1;
		if deck[card_id] == duplicates:
			pool.erase(card_id);
	return deck;
