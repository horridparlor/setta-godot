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
	DECK,
	FIELD,
	GRAVE,
	HAND,
	NONE,
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
	HAMMER_WAIFU,
}

static var CardName = {
	Card.HAMMER_WAIFU: "Hammer Waifu",
}
