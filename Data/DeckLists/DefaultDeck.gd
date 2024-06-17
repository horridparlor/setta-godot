extends Node

static func out():
	var deck_list : Dictionary = {
		CardEnums.DeckType.MAIN: {
			16: 40,
			63: 20,
		},
		CardEnums.DeckType.EXTRA: {
			71: 15,
		}
	};
	
	return deck_list;
