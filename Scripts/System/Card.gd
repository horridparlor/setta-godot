static func get_card_name(card : CardEnums.Card):
	return CardEnums.CardName[CardEnums.Card.HAMMER_WAIFU];

static func get_card_path(card : CardEnums.Card):
	return System.String_.serialize(get_card_name(card));
