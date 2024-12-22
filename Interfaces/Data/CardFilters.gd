extends Node
class_name CardFilters

const DEFAULT_CARD_TYPE : CardEnums.CardType = CardEnums.CardType.NONE;
const DEFAULT_SUBTYPE : CardEnums.CardSubtype = CardEnums.CardSubtype.NONE;
const DEFAULT_SUPERTYPE : CardEnums.CardSupertype = CardEnums.CardSupertype.NONE;
const DEFAULT_CARD_CLASS : CardEnums.Class = CardEnums.Class.NONE;
const DEFAULT_IS_ACE : SystemEnums.BooleanOption = SystemEnums.BooleanOption.NONE;
const DEFAULT_DECK : CardEnums.DeckType = CardEnums.DeckType.NONE;

var card_type : CardEnums.CardType;
var subtype : CardEnums.CardSubtype;
var supertype : CardEnums.CardSupertype;
var card_class : CardEnums.Class;
var is_ace : SystemEnums.BooleanOption;
var deck : CardEnums.DeckType;

func _init(
	card_type_ : CardEnums.CardType = DEFAULT_CARD_TYPE,
	subtype_ : CardEnums.CardSubtype = DEFAULT_SUBTYPE,
	supertype_ : CardEnums.CardSupertype = DEFAULT_SUPERTYPE,
	card_class_ : CardEnums.Class = DEFAULT_CARD_CLASS,
	is_ace_ : SystemEnums.BooleanOption = DEFAULT_IS_ACE,
	deck_ : CardEnums.DeckType = DEFAULT_DECK
):
	card_type = card_type_;
	subtype = subtype_;
	supertype = supertype_;
	card_class = card_class_;
	is_ace = is_ace_;
	deck = deck_;

func get_json() -> Dictionary:
	return {
		"cardType": card_type,
		"subtype": subtype,
		"supertype": supertype,
		"class": card_class,
		"isAce": is_ace,
		"deck": deck	
	};

func get_json_string() -> String:
	return JSON.stringify(get_json());

func is_filtering() -> bool:
	return card_type != DEFAULT_CARD_TYPE || subtype != DEFAULT_SUBTYPE \
		|| supertype != DEFAULT_SUPERTYPE || card_class != DEFAULT_CARD_CLASS \
		|| is_ace != DEFAULT_IS_ACE || deck != DEFAULT_DECK;
