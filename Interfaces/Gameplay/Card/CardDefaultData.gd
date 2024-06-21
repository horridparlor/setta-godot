extends Node
class_name CardDefaultData

var card_id: int;
var card_name : String;
var card_type : CardEnums.CardType;
var card_class : CardEnums.Class;
var subtype : CardEnums.CardSubtype;
var supertype : CardEnums.CardSupertype;
var materials : CardMaterials;
var effects_text : String;
var level : int;
var atk : int;
var def : int;

func _init(
	json_data : Dictionary
):
	card_id = json_data.cardId;
	card_name = json_data.cardName;
	card_type = CardEnums.enumerate_card_type(json_data.cardType);
	card_class = CardEnums.enumerate_class(json_data.cardClass);
	subtype = CardEnums.enumerate_subtype(json_data.subtype);
	supertype = CardEnums.enumerate_supertype(json_data.supertype);
	materials = eat_materials(json_data);
	effects_text = json_data.costText + json_data.effectText + json_data.flavourText;
	level = json_data.level;
	atk = json_data.atk;
	def = json_data.def;

func eat_materials(json_data : Dictionary) -> CardMaterials:
	return CardMaterials.new(
		json_data.primaryMaterialId,
		json_data.secondaryMaterialId,
		json_data.tertiaryMaterialId
	);

func to_json() -> Dictionary:
	return {
		"card_id": card_id,
		"card_name": card_name,
		"card_type": card_type,
		"card_class": card_class,
		"subtype": subtype,
		"supertype": supertype,
		"materials": materials.list(),
		"effects_text": effects_text,
		"level": level,
		"atk": atk,
		"def": def
	};
