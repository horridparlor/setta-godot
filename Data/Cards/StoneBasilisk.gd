extends Node

static func out(init_data : CardInitData):
	var card : CardEnums.Card = CardEnums.Card.STONE_BASILISK;
	var card_class : CardEnums.Class = CardEnums.Class.DRAGON;
	var card_type : CardEnums.CardType = CardEnums.CardType.MONSTER;
	var subtype : CardEnums.CardSubtype = CardEnums.CardSubtype.NORMAL;
	var special_types : SpecialTypes = SpecialTypes.new();
	
	var level : int = 6;
	var atk : int = 1600;
	var def : int = 2100;
	var monster_data : MonsterData = MonsterData.new(level, atk, def);
	
	var effects : CardEffects = CardEffects.new(null, null);
	var effect_text : String = "[i]Monsters lurking deep underground, these giant behemoths eat all the turds you flush down.[/i]";
	
	return CardData.new(
		card, card_class,
		card_type, subtype, special_types,
		effects, effect_text,
		init_data,
		monster_data
	);
