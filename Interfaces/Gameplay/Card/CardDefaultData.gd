extends Node
class_name CardDefaultData

var card_id : int;
var owner_id : int;
var card_name : String;
var is_ace : bool;
var card_type : CardEnums.CardType;
var card_class : CardEnums.Class;
var subtype : CardEnums.CardSubtype;
var supertype : CardEnums.CardSupertype;
var maximum_piece : CardEnums.MaximumPiece;
var materials : CardMaterials;
var effects_text : String;
var level : int;
var atk : int;
var def : int;
var text_sizes : CardTextSizes;

func _init(
	json_data : Dictionary
):
	card_id = json_data.cardId;
	owner_id = json_data.ownerId;
	card_name = json_data.cardName;
	is_ace = json_data.isAce;
	card_type = CardEnums.enumerate_card_type(json_data.cardType);
	card_class = CardEnums.enumerate_class(json_data.cardClass);
	subtype = CardEnums.enumerate_subtype(json_data.subtype);
	supertype = CardEnums.enumerate_supertype(json_data.supertype);
	maximum_piece = CardEnums.enumerate_maximum_piece(json_data.maximumPiece);
	materials = eat_materials(json_data);
	effects_text = eat_effects_text(json_data);
	level = json_data.level;
	atk = json_data.atk;
	def = json_data.def;
	text_sizes = eat_text_sizes(json_data);

func eat_effects_text(json_data : Dictionary) -> String:
	var materials_text : String = eat_materials_text(json_data);
	var cost_text : String = eat_cost_text(json_data);
	var effect_text : String = eat_effect_text(json_data);
	var flavour_text : String = eat_flavour_text(json_data);
	var counts_as_text : String = eat_counts_as_text(json_data);
	var portions : Array = [
		materials_text,
		cost_text,
		effect_text,
		flavour_text,
		counts_as_text	
	].filter(func(portion):
		return len(portion);
	);
	return "\n".join(portions);

func translate_encodings(message : String) -> String:
	return message\
		.replace(" {i}", "{i}")\
		.replace("{i}", "[i] (")\
		.replace("{/i}", ".)[/i]")\
		.replace("{sb}", "[code]")\
		.replace("{/sb}", "[/code]")\
		.replace("{b}", "[b]")\
		.replace("{/b}", "[/b]")\
	;

func eat_materials_text(json_data : Dictionary) -> String:
	var raw : String = "";
	return "" if len(raw) else "";

func eat_cost_text(json_data : Dictionary) -> String:
	var cost_prefix : String = "Pendulum>>" \
		if json_data.supertype == CardEnums.JSON_SUPERTYPE_PENDULUM else "Cost:";
	var raw : String = translate_encodings(json_data.costText);
	return "[i]%s [/i]%s" % [cost_prefix, raw] if len(raw) else "";

func eat_effect_text(json_data : Dictionary) -> String:
	var effect_prefix : String = "Hand Trap>>" \
		if json_data.supertype == CardEnums.JSON_SUPERTYPE_HAND_TRAP else "Effect:";
	var raw : String = translate_encodings(json_data.effectText);
	return "[i]%s [/i]%s" % [effect_prefix, raw] if len(raw) else "";

func eat_flavour_text(json_data : Dictionary) -> String:
	var raw : String = json_data.flavourText;
	return "[i]%s[/i]" % [raw] if len(raw) else "";

func eat_counts_as_text(json_data : Dictionary) -> String:
	var raw = json_data.countsAsId;
	return "Counts as a: %d" % [raw] if raw else "";

func eat_materials(json_data : Dictionary) -> CardMaterials:
	return CardMaterials.new(
		json_data.primaryMaterialId,
		json_data.secondaryMaterialId,
		json_data.tertiaryMaterialId
	);

func eat_text_sizes(json_data : Dictionary) -> CardTextSizes:
	return CardTextSizes.new(
		json_data.nameSize,
		json_data.materialsSize,
		json_data.effectsSize
	);

func to_json() -> Dictionary:
	return {
		"card_id": card_id,
		"owner_id": owner_id,
		"card_name": card_name,
		"is_ace": is_ace,
		"card_type": card_type,
		"card_class": card_class,
		"subtype": subtype,
		"supertype": supertype,
		"maximum_piece": maximum_piece,
		"materials": materials.list(),
		"effects_text": effects_text,
		"level": level,
		"atk": atk,
		"def": def,
		"text_sizes": text_sizes.list()
	};
