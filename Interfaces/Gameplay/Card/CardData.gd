extends CardDefaultData
class_name CardData

const STRING_FORMAT : String = "%s: %s";

var instance_id : int;
var sleeve : CardEnums.CardSleeve;
var monster_data : MonsterData;

var owning_player : GameplayEnums.OwningPlayer;
var controlling_player : GameplayEnums.OwningPlayer;
var zone : CardEnums.Zone = CardEnums.Zone.NONE;
var face : CardEnums.Face = CardEnums.Face.NONE;

func _init(
	card_id_ : int,
	init_data : CardInitData
):
	card_id = card_id_;
	eat_default(System.cards[card_id]);
	
	owning_player = init_data.owning_player;
	instance_id = System.Random.instance_id(init_data.random);
	sleeve = init_data.sleeve;
	zone = get_starting_deck();

func eat_default(json_data : Dictionary) -> void:
	owner_id = json_data.owner_id;
	card_name = json_data.card_name;
	card_type = json_data.card_type;
	card_class = json_data.card_class;
	subtype = json_data.subtype;
	supertype = json_data.supertype;
	materials = from_list(json_data.materials);
	effects_text = json_data.effects_text;
	if System.CardData.is_monster(self):
		level = json_data.level;
		atk = json_data.atk;
		def = json_data.def;
		monster_data = MonsterData.new(level, atk, def);

func from_list(source : Array) -> CardMaterials:
	var count : int = len(source);
	var primary = source[0] if count > 0 else null;
	var secondary = source[1] if count > 1 else null;
	var tertiary = source[2] if count > 2 else null;
	return CardMaterials.new(primary, secondary, tertiary);

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
