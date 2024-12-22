extends Node
class_name CardDefaultData

var card_id : int;
var errata_of_id : int;
var counts_as_id : int;
var owner_id : int;
var card_name : String;
var display_name : String;
var normalized_name : String;
var deck : CardEnums.DeckType;
var is_ace : bool;
var card_type : CardEnums.CardType;
var card_class : CardEnums.Class;
var secondary_class : CardEnums.Class;
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
	errata_of_id = json_data.errataOfId if json_data.errataOfId else 0;
	counts_as_id = json_data.countsAsId if json_data.countsAsId else 0;
	owner_id = json_data.ownerId;
	card_name = json_data.cardName;
	is_ace = json_data.isAce;
	card_type = CardEnums.enumerate_card_type(json_data.cardType);
	card_class = CardEnums.enumerate_class(json_data.cardClass);
	secondary_class = CardEnums.enumerate_class(json_data.secondaryClass);
	subtype = CardEnums.enumerate_subtype(json_data.subtype);
	supertype = CardEnums.enumerate_supertype(json_data.supertype);
	maximum_piece = CardEnums.enumerate_maximum_piece(json_data.maximumPiece);
	materials = eat_materials(json_data);
	effects_text = eat_effects_text(json_data);
	level = json_data.level;
	atk = json_data.atk;
	def = json_data.def;
	text_sizes = eat_text_sizes(json_data);
	
	display_name = get_display_name(json_data);
	normalized_name = System.CardData.get_normalized_name(self);
	deck = System.CardData.get_deck(self);

func get_display_name(json_data : Dictionary) -> String:
	return "[font_size=%d]%s[/font_size]"\
	% [
		SystemEnums.get_name_font_size(json_data.nameSize - 1),
		System.CardData.get_showcase_name(self)\
		.replace("{i}The{", "{i}The {")\
		.replace("{is}", "{i}[s]")\
		.replace("{/is}", "[/s]{/i}")\
		.replace("{i}", "[font=%s][font_size=%d]"\
			% [
				SystemEnums.get_bold_italic_font(),
				SystemEnums.get_name_font_size(json_data.nameSize - 2),
			])\
		.replace("{/i}", "[/font_size][/font]")\
		.replace("{bi}", "[font=%s][font_size=%d]"\
			% [
				SystemEnums.get_bold_italic_font(),
				SystemEnums.get_effects_font_size(SystemEnums.EffectsFontSize.DEFAULT),
			])\
		.replace("{/bi}", "[/font_size][/font]")\
		
	];

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
		.replace("{bi}", "[font=%s]" % [SystemEnums.get_bold_italic_font()])\
		.replace("{/bi}", "[/font]")\
	;

func eat_materials_text(json_data : Dictionary) -> String:
	var materials : Array = [
		json_data.primaryMaterialId,
		json_data.secondaryMaterialId,
		json_data.tertiaryMaterialId
	].filter(func(material):
		return material != null;	
	).map(func(material):
		return get_name_replacement_for_card_id(material);
	);
	var join_symbol : String = get_materials_join_symbol(json_data);
	var raw : String = (" %s " % [join_symbol]).join(materials);
	return "[font_size=%d][font=%s](%s)[/font][/font_size]%s"\
		% [
			translate_font_size(json_data.materialsSize),
			SystemEnums.get_heavy_font(),
			raw,
			get_materials_reminder(json_data)
		] if len(raw) else "";

func get_materials_reminder(json_data) -> String:
	var raw : String = json_data.materialsReminder;
	return "[font=%s] (%s.)[/font]"\
		% [
			SystemEnums.get_italic_font(),
			add_materials_font_size(raw, json_data)
		] if len(raw) else "";

func translate_font_size(size : int):
	return SystemEnums.get_effects_font_size(size - 1);

func get_name_replacement_for_card_id(card_id : int) -> String:
	return '{#' + str(card_id) + "}";

func get_materials_join_symbol(json_data : Dictionary) -> String:
	match json_data.subtype:
		CardEnums.JSON_SUBTYPE_FUSION:
			return "+";
		CardEnums.JSON_SUBTYPE_REVENGE:
			return "x";
		CardEnums.JSON_SUBTYPE_ROYAL:
			return "⋅";
		CardEnums.JSON_SUBTYPE_TIME_TRAVELLER:
			return "★";
		CardEnums.JSON_SUBTYPE_KILLER_MOVE:
			return "->";
	return "?";

func has_continuous_effect(json_data : Dictionary) -> bool:
	return json_data.cardEffects.cost.costType == CardEnums.JSON_COST_TYPE_CONTINUOUS;

func eat_cost_text(json_data : Dictionary) -> String:
	var cost_prefix : String = "Pendulum>>" \
		if json_data.supertype == CardEnums.JSON_SUPERTYPE_PENDULUM else "Continuous:" \
		if has_continuous_effect(json_data) else "Cost:";
	var raw : String = translate_encodings(json_data.costText);
	return "[i]%s [/i]%s"\
		% [
			add_materials_font_size(cost_prefix, json_data),
			add_materials_font_size(raw, json_data)
		] if len(raw.strip_edges()) else "";

func eat_effect_text(json_data : Dictionary) -> String:
	var effect_prefix : String = "Hand Trap>>" \
		if json_data.supertype == CardEnums.JSON_SUPERTYPE_HAND_TRAP else "Effect:";
	var raw : String = translate_encodings(json_data.effectText);
	return "[i]%s [/i]%s"\
		% [
			add_materials_font_size(effect_prefix, json_data),
			add_materials_font_size(raw, json_data)
		] if len(raw.strip_edges()) and !has_continuous_effect(json_data) else "";

func eat_flavour_text(json_data : Dictionary) -> String:
	var raw : String = json_data.flavourText;
	return "[i]%s[/i]"\
		% [
			add_materials_font_size(raw, json_data)
		] if len(raw.strip_edges()) else "";

func add_materials_font_size(message : String, json_data : Dictionary) -> String:
	return "[font_size=%d]%s[/font_size]" % [
		translate_font_size(json_data.effectsSize),
		message
	];

func eat_counts_as_text(json_data : Dictionary) -> String:
	var raw = json_data.countsAsId;
	return "[font_size=8]%s[/font_size]\n"\
		% ["–".repeat(90)]+\
	add_materials_font_size("Counts as a [font=%s]%s[/font]."\
		% [
			SystemEnums.get_bold_italic_font(),
			get_name_replacement_for_card_id(raw)
		], json_data) if raw else "";

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
		"errata_of_id": errata_of_id,
		"counts_as_id": counts_as_id,
		"owner_id": owner_id,
		"card_name": card_name,
		"display_name": display_name,
		"normalized_name": normalized_name,
		"deck": deck,
		"is_ace": is_ace,
		"card_type": card_type,
		"card_class": card_class,
		"secondary_class": secondary_class,
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
