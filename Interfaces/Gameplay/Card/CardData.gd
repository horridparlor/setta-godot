extends Node
class_name CardData

const STRING_FORMAT : String = "%s: %s";
const EXTRA_DECK_SUBTYPES : Array = [
	CardEnums.CardSubtype.FUSION,
	CardEnums.CardSubtype.REVENGE,
	CardEnums.CardSubtype.RITUAL,
	CardEnums.CardSubtype.ROYAL,
];

var card : CardEnums.Card;
var card_class : CardEnums.Class;
var card_type : CardEnums.CardType;
var subtype : CardEnums.CardSubtype;
var special_types : SpecialTypes;
var monster_data : MonsterData;
var effects : CardEffects;
var effect_text : String;
var instance_id : int;
var sleeve : CardEnums.CardSleeve;

var owning_player : GameplayEnums.OwningPlayer;
var controlling_player : GameplayEnums.OwningPlayer;
var zone : CardEnums.Zone = CardEnums.Zone.NONE;
var face : CardEnums.Face = CardEnums.Face.NONE;

func _init(
	card_ : CardEnums.Card,
	card_class_ : CardEnums.Class,
	card_type_ : CardEnums.CardType,
	subtype_ : CardEnums.CardSubtype,
	special_types_ : SpecialTypes,
	effects_ : CardEffects,
	effect_text_ : String,
	init_data : CardInitData,
	monster_data_ : MonsterData = null
):
	card = card_;
	card_class = card_class_;
	card_type = card_type_;
	subtype = subtype_;
	special_types = special_types_;
	effects = effects_;
	effect_text = effect_text_;
	instance_id = System.Random.instance_id(init_data.random);
	sleeve = init_data.sleeve;
	monster_data = monster_data_;
	zone = get_starting_deck();

func get_starting_deck() -> CardEnums.Zone:
	return CardEnums.Zone.EXTRA_DECK if subtype in EXTRA_DECK_SUBTYPES \
		else CardEnums.Zone.DECK;
	
func set_card() -> void:
	face = CardEnums.Face.DOWN;
	if monster_data:
		monster_data.to_defense_position();

func get_materials() -> Array:
	var materials : CardMaterials = effects.materials;
	return [
		materials.primary_material,
		materials.secondary_material,
		materials.tertiary_material
	];

func _to_string() -> String:
	return STRING_FORMAT % [instance_id, CardEnums.CardName[card]];
