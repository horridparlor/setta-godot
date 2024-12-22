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

static func get_deck(card_data : CardDefaultData) -> CardEnums.DeckType:
	return CardEnums.DeckType.MAIN if card_data.subtype in CardEnums.MAIN_DECK_SUBTYPES else CardEnums.DeckType.EXTRA;

static func is_main_deck(card_data : CardDefaultData) -> bool:
	return card_data.deck == CardEnums.DeckType.MAIN;

static func is_extra_deck(card_data : CardDefaultData) -> bool:
	return card_data.deck == CardEnums.DeckType.EXTRA;

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
	
static func from_id(card_id : int) -> CardData:
	return from_json(System.cards[card_id]);
	
static func is_deck_master(card_data : CardDefaultData) -> bool:
	return card_data.supertype == CardEnums.CardSupertype.DECK_MASTER;

static func get_max_copies(card_data : CardDefaultData) -> int:
	if is_extra_deck(card_data) || card_data.is_ace || is_deck_master(card_data):
		return 1;
	return System.Rules.MAX_COPIES;

static func sort_by_card_name(card_a : CardDefaultData, card_b : CardDefaultData) -> int:
	return card_a.normalized_name < card_b.normalized_name;	

static func get_deck_sort_index(card_data : CardDefaultData) -> int:
	if is_main_deck(card_data):
		return 0;
	return 1;

static func sort_json_by_card_type(card_a : Dictionary, card_b : Dictionary) -> int:
	return sort_by_card_type(from_json(card_a), from_json(card_b));

static func get_monster_sort_index(card_data : CardDefaultData) -> int:
	return 10000000 * card_data.level + 1000 * card_data.atk + card_data.def;

static func sort_by_card_type(card_a : CardDefaultData, card_b : CardDefaultData) -> int:
	var sided_sort_a : int = int(in_side_deck(card_a));
	var sided_sort_b : int = int(in_side_deck(card_b));
	var deck_sort_a : int = get_deck_sort_index(card_a);
	var deck_sort_b : int = get_deck_sort_index(card_b);
	var monster_sort_a : int;
	var monster_sort_b : int;
	if sided_sort_a != sided_sort_b:
		return sided_sort_a < sided_sort_b;
	if deck_sort_a != deck_sort_b:
		return deck_sort_a < deck_sort_b;
	if card_a.card_type != card_b.card_type:
		return card_a.card_type < card_b.card_type;
	if card_a.subtype != card_b.subtype:
		return card_a.subtype < card_b.subtype;
	if card_a.supertype != card_b.supertype:
		return card_a.supertype < card_b.supertype;
	if is_monster(card_a):
		monster_sort_a = get_monster_sort_index(card_a);
		monster_sort_b = get_monster_sort_index(card_b);
		if monster_sort_a != monster_sort_b:
			return monster_sort_a < monster_sort_b;
	return sort_by_card_name(card_a, card_b);

static func in_side_deck(card_data : CardData) -> bool:
	return card_data.deck_portion == CardEnums.DeckPortion.SIDE_DECK;

static func in_main_deck(card_data : CardData) -> bool:
	return !in_side_deck(card_data);

static func get_all_cards() -> Array:
	var cards : Array;
	for card in System.cards.values():
		cards.append(from_json(card));
	cards.sort_custom(sort_by_card_type);
	return cards;

static func is_monster_class(card_class : CardEnums.Class) -> bool:
	return card_class != CardEnums.Class.NONE;

static func get_classes(card_data : CardData) -> Dictionary:
	var monster_classes : Array = [card_data.card_class, card_data.secondary_class].filter(is_monster_class);
	var classes : Dictionary;
	for monster_class in monster_classes:
		classes[monster_class] = null;
	return classes;

static func can_be_with_deckmaster(card_data : CardData, deckmaster : CardData) -> bool:
	var allowed_classes : Dictionary = get_classes(deckmaster);
	if !is_monster(card_data) || card_data.card_id == deckmaster.card_id:
		return true;
	if is_deck_master(card_data):
		return false;
	for card_class in get_classes(card_data):
		if !allowed_classes.has(card_class):
			return false;
	return true;

static func get_ace_gategory(card_data : CardData, treat_as_main_deck_card : bool = false) -> CardEnums.AceCategory:
	if System.CardData.in_side_deck(card_data) && !treat_as_main_deck_card:
		return CardEnums.AceCategory.NONE;
	if System.CardData.is_extra_deck(card_data):
		return CardEnums.AceCategory.EXTRA;
	match card_data.card_type:
		CardEnums.CardType.MONSTER:
			return CardEnums.AceCategory.MONSTER;
		CardEnums.CardType.SPELL:
			return CardEnums.AceCategory.SPELL;
		CardEnums.CardType.TRAP:
			return CardEnums.AceCategory.TRAP;
	return CardEnums.AceCategory.NONE;

static func get_referenced_ids(card_data : CardData) -> Dictionary:
	var ids : Dictionary;
	var valid_ids : Array = [
		card_data.card_id,
		card_data.errata_of_id,
		card_data.counts_as_id,
		card_data.materials.primary_material_id,
		card_data.materials.secondary_material_id,
		card_data.materials.tertiary_material_id
	].filter(func(value): return value);
	for id in valid_ids:
		ids[int(id)] = null;
	return ids;

static func is_referenced_by(card_data : CardData, referenced_card : CardData) -> bool:
	var referenced_ids : Dictionary = get_referenced_ids(referenced_card);
	for id in get_referenced_ids(card_data):
		if referenced_ids.has(id):
			return true;
	return false;

static func has_search_string(card_data : CardData, message : String) -> bool:
	return card_data.normalized_name.to_lower().contains(message) \
		|| card_data.effects_text.to_lower().contains(message);

static func matches_filters(card_data : CardData, card_filters : CardFilters) -> bool:
	if card_filters.card_type != CardFilters.DEFAULT_CARD_TYPE && \
	card_data.card_type != card_filters.card_type:
		return false;
	if card_filters.subtype != CardFilters.DEFAULT_SUBTYPE && \
	card_data.subtype != card_filters.subtype:
		return false;
	if card_filters.supertype != CardFilters.DEFAULT_SUPERTYPE && \
	card_data.supertype != card_filters.supertype:
		return false;
	if card_filters.card_class != CardFilters.DEFAULT_CARD_CLASS && \
	card_data.card_class != card_filters.card_class:
		return false;
	if card_filters.is_ace != CardFilters.DEFAULT_IS_ACE && \
	card_data.is_ace != System.Enums.read_boolean(card_filters.is_ace):
		return false;
	if card_filters.deck != CardFilters.DEFAULT_DECK && \
	card_data.deck != card_filters.deck:
		return false;
	return true;
