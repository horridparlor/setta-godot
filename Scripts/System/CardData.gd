const CARD_DATA_PREFIX : String = "res://Data/Cards/";
const SUBFIX : String = ".gd";

static func is_fast(card : CardData) -> bool:
	return card.color == CardEnums.CardColor.PURPLE;

static func discard_from_field(card : CardData, player : PlayerData, erased : Dictionary) -> void:
	player.cards_on_field.erase(card);
	player.cards_in_grave.append(card);
	erased[card.instance_id] = null;
	card.is_used = true;
	
static func discard_from_hand(card : CardData, player : PlayerData, erased : Dictionary) -> void:
	player.cards_in_hand.erase(card);
	player.cards_in_grave.append(card);
	erased[card.instance_id] = null;
	card.is_used = false;

static func get_is_negated(card : CardData, gameplay : Gameplay) -> bool:
	return card.subtype in gameplay.negated_subtypes;

static func get_normalized_name(card_data : CardDefaultData) -> String:
	var i_the : RegEx = RegEx.new();
	var encodings : RegEx = RegEx.new();

	i_the.compile("{i}The");
	encodings.compile("{[^}]*}");

	var result : String = get_showcase_name(card_data);
	result = i_the.sub(result, "{i}", 1);
	result = encodings.sub(result, "", 1);

	var special_chars : Array = [
		'!', '?', '–', ',', ':', 'á',
		'ä', 'é', 'ö', '$', '[', ']', ' '
	];

	var normalized = "";
	for i in result:
		if i.is_valid_identifier() or i in special_chars:
			normalized += i;

	return normalized;


static func get_serialized_name(card_data : CardDefaultData) -> String:
	var serialized : String = get_normalized_name(card_data)\
		.replace("á", "a")\
		.replace("ä", "a")\
		.replace("é", "e")\
		.replace("€", "e")\
		.replace("ó", "o")\
		.replace("ö", "o")\
		.replace("ś", "s")\
		.replace("$", "s")\
		.replace("-", "")\
		.replace("'", "")\
		.replace("!", "")\
		.replace("?", "")\
		.replace("–", "")\
		.replace(",", "")\
		.replace(":", "")\
		.replace("[", "")\
		.replace("]", "")

	var words : Array = serialized.split(" ");
	for i in range(words.size()):
		words[i] = System.String_.cap_first(words[i]);

	return "".join(words);

static func default(init_data : CardInitData) -> CardData:
	var card : CardData = CardData.new(
		16,
		init_data
	);
	card.zone = CardEnums.Zone.SHOWCASE;
	return card;

static func is_main_deck(card_data : CardDefaultData) -> bool:
	return card_data.subtype in CardEnums.MAIN_DECK_SUBTYPES;

static func is_extra_deck(card_data : CardDefaultData) -> bool:
	return card_data.subtype not in CardEnums.MAIN_DECK_SUBTYPES;

static func is_monster(card_data : CardDefaultData) -> bool:
	return card_data.card_type == CardEnums.CardType.MONSTER;

static func get_attribute_name(card_data : CardDefaultData) -> String:
	if is_monster(card_data):
		return CardEnums.ClassName[card_data.card_class];
	return CardEnums.CardTypeName[card_data.card_type];

static func is_normal(card_data : CardDefaultData) -> bool:
	return card_data.subtype == CardEnums.CardSubtype.NORMAL;

static func has_supertype(card_data : CardDefaultData) -> bool:
	return card_data.supertype != CardEnums.CardSupertype.NONE;

static func get_middle_frame_name(card_data : CardDefaultData) -> String:
	if is_normal(card_data):
		if is_monster(card_data):
			if has_supertype(card_data):
				return System.String_.serialize(CardEnums.CardSupertypeName[card_data.supertype]);
		else:
			return CardEnums.CardTypeName[card_data.card_type];
	return System.String_.serialize(CardEnums.CardSubtypeName[card_data.subtype]);

static func is_maximum(card_data : CardDefaultData) -> bool:
	return card_data.supertype == CardEnums.CardSupertype.MAXIMUM;

static func get_showcase_name(card_data : CardDefaultData) -> String:
	var maximum_string : String = \
		"" if !is_maximum(card_data) \
		else " " + "[%c]" % [CardEnums.MaximumPieceName[card_data.maximum_piece][0]];
	return card_data.card_name + maximum_string;
