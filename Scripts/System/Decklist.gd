enum Premade {
	DEFAULT
}

static var PremadePath = {
	Premade.DEFAULT: "DefaultDeck",
}

static func premade(decklist : Premade):
	return Decklist.new(
		GameplayEnums.DecklistType.PREMADE,
		PremadePath[decklist]
	)
