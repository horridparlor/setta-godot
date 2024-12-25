static func get_random() -> Decklist:
	return Decklist.new(
		get_random_main_deck(),
		get_random_extra_deck()
	);

static func get_random_main_deck() -> Dictionary:
	var size : int = System.Rules.MAIN_DECK_SIZE;
	var overwrite_card_id : int = System.Debug.OVERWRITE_CARD_ID;
	if overwrite_card_id:
		return {overwrite_card_id: size}
	return get_random_deck(
		size,
		System.main_deck_cards,
		System.Rules.MAX_COPIES
	);

static func get_random_extra_deck() -> Dictionary:
	return get_random_deck(System.Rules.EXTRA_DECK_SIZE, System.extra_deck_cards);

static func get_random_deck(
	size : int, source : Dictionary, duplicates : int = 1
) -> Dictionary:
	var deck : Dictionary;
	var card_id : int;
	var filled : int;
	var pool : Dictionary = source.duplicate();
	for i in range(size):
		card_id = System.Random.key(pool);
		if deck.has(card_id):
			deck[card_id] += 1;
		else:
			deck[card_id] = 1;
		if deck[card_id] == duplicates or source[card_id].is_ace:
			pool.erase(card_id);
			if pool.is_empty():
				return deck;
	return deck;

static func set_decklists_from_json(source : Array) -> void:
	var decklists : Dictionary;
	for decklist in source:
		decklists[int(decklist.decklistId)] = decklist;
	System.decklists = decklists;
	System.Json.write({"decklists": source}, SystemEnums.SaveFilePath[SystemEnums.SaveFile.DECKLISTS]);

static func set_decklists(decklists : Dictionary) -> void:
	var source : Array;
	var decklist : DecklistData;
	for list in decklists.values():
		decklist = list;
		source.append(decklist.get_json());
	set_decklists_from_json(source);
