extends Node

enum CardType {
	MONSTER,
	NONE,
	SPELL,
	TRAP
}

const JSON_TYPE_MONSTER : String = "Monster";
const JSON_TYPE_SPELL : String = "Spell";
const JSON_TYPE_TRAP : String = "Trap";

static var CardTypeName = {
	CardType.MONSTER: JSON_TYPE_MONSTER,
	CardType.SPELL: JSON_TYPE_SPELL,
	CardType.TRAP: JSON_TYPE_TRAP,
}

static func enumerate_card_type(message : String) -> CardType:
	match message:
		JSON_TYPE_MONSTER:
			return CardType.MONSTER;
		JSON_TYPE_SPELL:
			return CardType.SPELL;
		_:
			return CardType.TRAP;

enum DeckType {
	NONE,
	MAIN,
	EXTRA
}

const JSON_DECK_MAIN : String = "Main";
const JSON_DECK_EXTRA : String = "Extra";

static var DeckTypeName = {
	DeckType.MAIN: JSON_DECK_MAIN,
	DeckType.EXTRA: JSON_DECK_EXTRA
}

enum CardSubtype {
	NONE,
	NORMAL,
	EFFECT,
	FUSION,
	REVENGE,
	ROYAL,
	TIME_TRAVELLER,
	KILLER_MOVE
}

const MAIN_DECK_SUBTYPES : Array = [
	CardSubtype.EFFECT,
	CardSubtype.NORMAL,
]

const JSON_SUBTYPE_EFFECT : String = "Effect";
const JSON_SUBTYPE_FUSION : String = "Fusion";
const JSON_SUBTYPE_NORMAL : String = "Normal";
const JSON_SUBTYPE_REVENGE : String = "Revenge";
const JSON_SUBTYPE_KILLER_MOVE : String = "Killer Move";
const JSON_SUBTYPE_ROYAL : String = "Royal";
const JSON_SUBTYPE_TIME_TRAVELLER : String = "Time Traveller";

static var CardSubtypeName = {
	CardSubtype.EFFECT: JSON_SUBTYPE_EFFECT,
	CardSubtype.FUSION: JSON_SUBTYPE_FUSION,
	CardSubtype.NORMAL: JSON_SUBTYPE_NORMAL,
	CardSubtype.REVENGE: JSON_SUBTYPE_REVENGE,
	CardSubtype.KILLER_MOVE: JSON_SUBTYPE_KILLER_MOVE,
	CardSubtype.ROYAL: JSON_SUBTYPE_ROYAL,
	CardSubtype.TIME_TRAVELLER: JSON_SUBTYPE_TIME_TRAVELLER
}

static func enumerate_subtype(message : String) -> CardSubtype:
	match message:
		JSON_SUBTYPE_EFFECT:
			return CardSubtype.EFFECT;
		JSON_SUBTYPE_FUSION:
			return CardSubtype.FUSION;
		JSON_SUBTYPE_NORMAL:
			return CardSubtype.NORMAL;
		JSON_SUBTYPE_REVENGE:
			return CardSubtype.REVENGE;
		JSON_SUBTYPE_KILLER_MOVE:
			return CardSubtype.KILLER_MOVE;
		JSON_SUBTYPE_ROYAL:
			return CardSubtype.ROYAL;
		JSON_SUBTYPE_TIME_TRAVELLER:
			return CardSubtype.TIME_TRAVELLER;
		_:
			return CardSubtype.NONE;

enum CardSupertype {
	DECK_MASTER,
	HAND_TRAP,
	MAXIMUM,
	PENDULUM,
	NONE
}

const JSON_SUPERTYPE_DECK_MASTER : String = "Deck Master";
const JSON_SUPERTYPE_HAND_TRAP : String = "Hand Trap";
const JSON_SUPERTYPE_MAXIMUM : String = "Maximum";
const JSON_SUPERTYPE_PENDULUM : String = "Pendulum";

static var CardSupertypeName = {
	CardSupertype.DECK_MASTER: JSON_SUPERTYPE_DECK_MASTER,
	CardSupertype.HAND_TRAP: JSON_SUPERTYPE_HAND_TRAP,
	CardSupertype.MAXIMUM: JSON_SUPERTYPE_MAXIMUM,
	CardSupertype.PENDULUM: JSON_SUPERTYPE_PENDULUM
}

static func enumerate_supertype(message : String) -> CardSupertype:
	match message:
		JSON_SUPERTYPE_DECK_MASTER:
			return CardSupertype.DECK_MASTER;
		JSON_SUPERTYPE_HAND_TRAP:
			return CardSupertype.HAND_TRAP;
		JSON_SUPERTYPE_MAXIMUM:
			return CardSupertype.MAXIMUM;
		JSON_SUPERTYPE_PENDULUM:
			return CardSupertype.PENDULUM;
		_:
			return CardSupertype.NONE;

enum Zone {
	BACKROW,
	CARD_CATALOGUE,
	DECK,
	EXTRA_DECK,
	FIELD,
	GRAVE,
	HAND,
	MODAL,
	NONE,
	REMOVED,
	SHOWCASE
}

enum DeckPortion {
	MAIN_DECK,
	SIDE_DECK
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
	NONE,
	ABYSS,
	DRAGON,
	KAWAII,
	SLIME,
	SPARKS,
	ZOMBIE,
}

const JSON_CLASS_ABYSS : String = "Abyss";
const JSON_CLASS_DRAGON : String = "Dragon";
const JSON_CLASS_KAWAII : String = "Kawaii";
const JSON_CLASS_SLIME : String = "Slime";
const JSON_CLASS_SPARKS : String = "Sparks";
const JSON_CLASS_ZOMBIE : String = "Zombie";

static var ClassName = {
	Class.ABYSS: JSON_CLASS_ABYSS,
	Class.DRAGON: JSON_CLASS_DRAGON,
	Class.KAWAII: JSON_CLASS_KAWAII,
	Class.SLIME: JSON_CLASS_SLIME,
	Class.SPARKS: JSON_CLASS_SPARKS,
	Class.ZOMBIE: JSON_CLASS_ZOMBIE,
}

static func enumerate_class(message : String) -> Class:
	match message:
		JSON_CLASS_ABYSS:
			return Class.ABYSS;
		JSON_CLASS_DRAGON:
			return Class.DRAGON;
		JSON_CLASS_KAWAII:
			return Class.KAWAII;
		JSON_CLASS_SLIME:
			return Class.SLIME;
		JSON_CLASS_SPARKS:
			return Class.SPARKS;
		JSON_CLASS_ZOMBIE:
			return Class.ZOMBIE;
		_:
			return Class.NONE;

enum MaximumPiece {
	LEFT,
	MIDDLE,
	NONE,
	RIGHT
}

const JSON_MAXIMUM_PIECE_LEFT : String = "Left";
const JSON_MAXIMUM_PIECE_MIDDLE : String = "Middle";
const JSON_MAXIMUM_PIECE_RIGHT : String = "Right";

static var MaximumPieceName = {
	MaximumPiece.LEFT: JSON_MAXIMUM_PIECE_LEFT,
	MaximumPiece.MIDDLE: JSON_MAXIMUM_PIECE_MIDDLE,
	MaximumPiece.RIGHT: JSON_MAXIMUM_PIECE_RIGHT
}

static func enumerate_maximum_piece(message : String) -> MaximumPiece:
	match message:
		JSON_MAXIMUM_PIECE_LEFT:
			return MaximumPiece.LEFT;
		JSON_MAXIMUM_PIECE_MIDDLE:
			return MaximumPiece.MIDDLE;
		JSON_MAXIMUM_PIECE_RIGHT:
			return MaximumPiece.RIGHT;
		_:
			return MaximumPiece.NONE;

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
	TRIBUTE,
}

enum CardSleeve {
	DEFAULT,
}

static var CardSleevePath = {
	CardSleeve.DEFAULT: "DefaultSleeve",
}

const JSON_COST_TYPE_CONTINUOUS : String = "Continuous";

enum AceCategory {
	NONE,
	MONSTER,
	SPELL,
	TRAP,
	EXTRA
}
