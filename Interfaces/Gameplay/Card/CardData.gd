extends CardDefaultData
class_name CardData

const STRING_FORMAT : String = "%s: %s";

var instance_id : int;
var sleeve : CardEnums.CardSleeve;
var monster_data : MonsterData;

var max_copies : int;

var owning_player : GameplayEnums.OwningPlayer;
var controlling_player : GameplayEnums.OwningPlayer;
var zone : CardEnums.Zone = CardEnums.Zone.NONE;
var face : CardEnums.Face = CardEnums.Face.NONE;
var deck_portion : CardEnums.DeckPortion = CardEnums.DeckPortion.MAIN_DECK;

func _init(
	card_id_ : int,
	init_data : CardInitData
):
	card_id = card_id_;
	if System.cards.has(card_id):
		eat_default(System.cards[card_id]);
	
	owning_player = init_data.owning_player;
	instance_id = System.Random.instance_id();
	sleeve = init_data.sleeve;
	zone = get_starting_deck();

func eat_default(json_data : Dictionary) -> void:
	errata_of_id = json_data.errata_of_id;
	counts_as_id = json_data.counts_as_id;
	owner_id = json_data.owner_id;
	card_name = json_data.card_name;
	display_name = json_data.display_name;
	normalized_name = json_data.normalized_name;
	is_ace = json_data.is_ace;
	card_type = json_data.card_type;
	card_class = json_data.card_class;
	secondary_class = json_data.secondary_class;
	subtype = json_data.subtype;
	supertype = json_data.supertype;
	maximum_piece = json_data.maximum_piece;
	materials = CardMaterials.from_list(json_data.materials);
	text_sizes = CardTextSizes.from_list(json_data.text_sizes);
	effects_text = add_card_names(json_data.effects_text);
	if System.CardData.is_monster(self):
		level = json_data.level;
		atk = json_data.atk;
		def = json_data.def;
		monster_data = MonsterData.new(level, atk, def);
	max_copies = System.CardData.get_max_copies(self);

func add_card_names(effects_text : String) -> String:
	var regex_match : RegExMatch;
	var regex : RegEx = RegEx.new();
	regex.compile("{#\\d+}");
	var matches : Array = regex.search_all(effects_text);
	var result : String = effects_text;
	matches.reverse();
	for m in matches:
		regex_match = m;
		var card_id : int = int(regex_match.get_string());
		var card_name : String = System.cards[card_id].normalized_name;
		result = result.substr(
			0, regex_match.get_start())\
			+ card_name + result.substr(regex_match.get_end(),\
			result.length() - regex_match.get_end()
		);
	return result;

func get_starting_deck() -> CardEnums.Zone:
	return CardEnums.Zone.EXTRA_DECK if System.CardData.is_extra_deck(self) \
		else CardEnums.Zone.DECK;
	
func set_card() -> void:
	face = CardEnums.Face.DOWN;
	if monster_data:
		monster_data.position = CardEnums.MonsterPosition.DEFENSE;

func get_materials() -> Array:
	return materials.list() if materials else [];

func _to_string() -> String:
	return STRING_FORMAT % [instance_id, card_name];

func get_position() -> CardEnums.MonsterPosition:
	return monster_data.position if monster_data else CardEnums.MonsterPosition.ATTACK;

func move_to_main_deck() -> void:
	deck_portion = CardEnums.DeckPortion.MAIN_DECK;

func move_to_side_deck() -> void:
	deck_portion = CardEnums.DeckPortion.SIDE_DECK;

func copy() -> CardData:
	return System.CardData.from_json(to_json());
