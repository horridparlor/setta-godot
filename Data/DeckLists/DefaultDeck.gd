extends Node

static func out():
	var deck_list : Dictionary = {
		CardEnums.DeckType.MAIN: {
			CardEnums.Card.HAMMER_WAIFU: 40,
			CardEnums.Card.STONE_BASILISK: 20,
		},
		CardEnums.DeckType.EXTRA: {
			CardEnums.Card.BROTHERS_IN_WAR: 18,
		}
	};
	
	return deck_list;
