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

static func create(card : CardEnums.Card, init_data : CardInitData, \
 owning_player : GameplayEnums.OwningPlayer = GameplayEnums.OwningPlayer.YOU) -> CardData:
	var card_data : CardData = load(CARD_DATA_PREFIX + System.Card.get_card_path(card) + SUBFIX).out(init_data);
	card_data.owning_player = owning_player;
	return card_data;

static func get_card_name(card_data : CardData) -> String:
	print(System.cards);
	return System.cards[card_data.card_id].cardName;

static func get_serialized_name(card_data : CardData) -> String:
	var card_name = get_card_name(card_data)
	card_name = card_name\
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

	var words = card_name.split(" ");
	for i in range(words.size()):
		words[i] = words[i].capitalize();

	card_name = "".join(words);
	return card_name;

static func default(init_data : CardInitData) -> CardData:
	var card : CardData = CardData.new(
		16,
		CardEnums.Card.NONE,
		CardEnums.Class.NONE,
		CardEnums.CardType.NONE,
		CardEnums.CardSubtype.NONE,
		null,
		null,
		"",
		init_data,
		null
	);
	card.zone = CardEnums.Zone.SHOWCASE;
	return card;
