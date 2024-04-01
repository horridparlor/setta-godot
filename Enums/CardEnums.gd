extends Node

enum CardType {
	MONSTER,
	SPELL,
	TRAP
}

static var card_type_to_string = {
	CardType.MONSTER: "Monster",
	CardType.SPELL: "Spell",
	CardType.TRAP: "Trap",
}

enum DeckType {
	MAIN,
	EXTRA
}

enum CardSubtype {
	EFFECT,
	FUSION,
	NORMAL,
	REVENGE,
	RITUAL,
	ROYAL,
}

static var subtype_to_string = {
	CardSubtype.EFFECT: "Effect",
	CardSubtype.FUSION: "Fusion",
	CardSubtype.NORMAL: "Normal",
	CardSubtype.REVENGE: "Revenge",
	CardSubtype.RITUAL: "Ritual",
	CardSubtype.ROYAL: "Royal",
}

enum Zone {
	BACKROW,
	DECK,
	EXTRA_DECK,
	FIELD,
	GRAVE,
	HAND,
	NONE,
	REMOVED,
	SHOWCASE,
}

enum Face {
	DOWN,
	NONE,
	UP	
}

enum MonsterPosition {
	ATTACK,
	DEFENSE
}

enum Class {
	ABYSS,
	DRAGON,
	KAWAII,
	SLIME,
	SPARKS,
	SPELL,
	TRAP,
	ZOMBIE,
}

static var ClassName = {
	Class.ABYSS: "Abyss",
	Class.DRAGON: "Dragon",
	Class.KAWAII: "Kawaii",
	Class.SLIME: "Slime",
	Class.SPARKS: "Sparks",
	Class.SPELL: "Spell",
	Class.TRAP: "Trap",
	Class.ZOMBIE: "Zombie",
}

enum Card {
	BROTHERS_IN_WAR,
	HAMMER_WAIFU,
	NONE,
	STONE_BASILISK,
}

static var CardName = {
	Card.BROTHERS_IN_WAR: "Brothers in War",
	Card.HAMMER_WAIFU: "Hammer Waifu",
	Card.STONE_BASILISK: "Stone Basilisk"
}

enum MaximumMonster {
	HORSE_RAVEN,
	NITROPUS,
	NONE
}

enum MaximumPiece {
	LEFT,
	MIDDLE,
	NONE,
	RIGHT
}

enum CardAction {
	ACTIVATE,
	ATTACK,
	BATTLE,
	DEFENSE,
	FLIP,
	MAXIMUM,
	SCALE,
	SET,
	SUMMON,
}

enum CardSleeve {
	DEFAULT,
}

static var CardSleevePath = {
	CardSleeve.DEFAULT: "DefaultSleeve",
}
