static func is_deck_master(block : NexusEnums.DecklistBlock) -> bool:
	return block == NexusEnums.DecklistBlock.DECK_MASTER;

static func to_json(block : NexusEnums.DecklistBlock) -> String:
	match block:
		NexusEnums.DecklistBlock.DECK_MASTER:
			return 'deckMaster';
		NexusEnums.DecklistBlock.MONSTER:
			return 'monster';
		NexusEnums.DecklistBlock.SPELL:
			return 'spell';
		NexusEnums.DecklistBlock.TRAP:
			return 'trap';
		NexusEnums.DecklistBlock.EXTRA:
			return 'extra';
		NexusEnums.DecklistBlock.SIDE:
			return 'side';
	return 'monster';
