static func is_deck_master(block : NexusEnums.DecklistBlock) -> bool:
	return block == NexusEnums.DecklistBlock.DECK_MASTER;

static func is_side_deck(block : NexusEnums.DecklistBlock) -> bool:
	return block == NexusEnums.DecklistBlock.SIDE;

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

static func to_enum(block : String) -> NexusEnums.DecklistBlock:
	match block:
		'deckMaster':
			return NexusEnums.DecklistBlock.DECK_MASTER;
		'monster':
			return NexusEnums.DecklistBlock.MONSTER;
		'spell':
			return NexusEnums.DecklistBlock.SPELL;
		'trap':
			return NexusEnums.DecklistBlock.TRAP;
		'extra':
			return NexusEnums.DecklistBlock.EXTRA;
		'side':
			return NexusEnums.DecklistBlock.SIDE;
	return NexusEnums.DecklistBlock.MONSTER;
