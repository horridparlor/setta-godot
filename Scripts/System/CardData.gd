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

	const special_chars : Array = [
		'!', '?', '-', '–', ',', ':', 'á', '\'',
		'ä', 'é', 'ö', '$', '[', ']', ' '
	];
	
	const digits : Array = [
		'0', '1', '2', '3', '4', '5',
		'6', '7', '8', '9'
	]

	var normalized = "";
	for i in result:
		if i.is_valid_identifier() or i in special_chars or i in digits:
			normalized += i;

	return normalized.replace("  ", " ");


static func get_serialized_name(card_data : CardDefaultData) -> String:
	var serialized : String = card_data.normalized_name\
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

static func get_uses_white_text(card_data : CardDefaultData) -> bool:
	return card_data.subtype in [
		CardEnums.CardSubtype.ROYAL,
		CardEnums.CardSubtype.TIME_TRAVELLER	
	];

static func get_text_color_by_frame(card_data : CardDefaultData) -> Color:
	return SystemEnums.TEXT_COLOR_PEARL_WHITE\
		if get_uses_white_text(card_data)\
		else SystemEnums.TEXT_COLOR_BLACK;

static func get_default_card_init_data() -> CardInitData:
	return CardInitData.new(GameplayEnums.OwningPlayer.YOU, CardEnums.CardSleeve.DEFAULT);

static func from_json(json_data : Dictionary) -> CardData:
	var card_data : CardData = CardData.new(json_data.card_id, get_default_card_init_data());
	card_data.eat_default(json_data);
	return card_data;
	
static func is_deck_master(card_data : CardData) -> bool:
	return card_data.supertype == CardEnums.CardSupertype.DECK_MASTER;

static func get_max_copies(card_data : CardData) -> int:
	if is_extra_deck(card_data) || card_data.is_ace || is_deck_master(card_data):
		return 1;
	return PlayerData.MAIN_DECK_DUPLICATES;
