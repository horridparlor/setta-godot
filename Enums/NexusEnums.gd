extends Node

enum NexusPage {
	SHOP,
	DECKS,
	BATTLE,
	ROGUE,
	NEWS,
}

static func translate_nexus_page(page : NexusEnums.NexusPage) -> String:
	match page:
		NexusPage.SHOP:
			return "Shop";
		NexusPage.DECKS:
			return "Decks";
		NexusPage.BATTLE:
			return "Battle";
		NexusPage.ROGUE:
			return "Rogue";
		NexusPage.NEWS:
			return "News";
	return "Page";

static func get_nexus_page_index(page: NexusEnums.NexusPage) -> int:
	match page:
		NexusPage.SHOP:
			return 1;
		NexusPage.DECKS:
			return 2;
		NexusPage.BATTLE:
			return 3;
		NexusPage.ROGUE:
			return 4;
		NexusPage.NEWS:
			return 5;
	return 0;
