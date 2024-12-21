extends Node

enum NexusPages {
	NONE,
	SHOP,
	DECKS,
	BATTLE,
	ROGUE,
	NEWS,
}

static func translate_nexus_page(page : NexusPages) -> String:
	match page:
		NexusPages.SHOP:
			return "Shop";
		NexusPages.DECKS:
			return "Decks";
		NexusPages.BATTLE:
			return "Battle";
		NexusPages.ROGUE:
			return "Rogue";
		NexusPages.NEWS:
			return "News";
	return "Page";

static func get_nexus_page_index(page: NexusPages) -> int:
	match page:
		NexusPages.SHOP:
			return 1;
		NexusPages.DECKS:
			return 2;
		NexusPages.BATTLE:
			return 3;
		NexusPages.ROGUE:
			return 4;
		NexusPages.NEWS:
			return 5;
	return 0;

enum DecklistBlock {
	DECK_MASTER,
	MONSTER,
	SPELL,
	TRAP,
	EXTRA,
	SIDE
}

static var DecklistBlockNames = {
	NexusEnums.DecklistBlock.DECK_MASTER : "Deck Master",
	NexusEnums.DecklistBlock.MONSTER : "Monsters",
	NexusEnums.DecklistBlock.SPELL : "Spells",
	NexusEnums.DecklistBlock.TRAP : "Traps",
	NexusEnums.DecklistBlock.EXTRA : "Extra",
	NexusEnums.DecklistBlock.SIDE : "Side"
};
