extends Node

static func out(init_data : CardInitData):
	var card : CardEnums.Card = CardEnums.Card.BROTHERS_IN_WAR;
	var card_class : CardEnums.Class = CardEnums.Class.DRAGON;
	var card_type : CardEnums.CardType = CardEnums.CardType.MONSTER;
	var subtype : CardEnums.CardSubtype = CardEnums.CardSubtype.FUSION;
	var special_types : SpecialTypes = SpecialTypes.new();
	
	var level : int = 8;
	var atk : int = 2000;
	var def : int = 2500;
	var monster_data : MonsterData = MonsterData.new(level, atk, def);
	
	var materials : CardMaterials = CardMaterials.new(
		CardEnums.Card.HAMMER_WAIFU,
		CardEnums.Card.STONE_BASILISK,	
	);
	var effect_cost : EffectCost = EffectCost.new(
		EffectEnums.CostType.MILL,
		EffectTarget.new(EffectEnums.TargetType.DEFAULT),
		1
	);
	var effect_effect : EffectEffect = EffectEffect.new(
		EffectEnums.EffectType.ATK_LOSE,
		EffectTarget.new(EffectEnums.TargetType.TARGET_MONSTER),
		1000
	);
	var effects : CardEffects = CardEffects.new(effect_cost, effect_effect, materials);
	var effect_text : String = SystemEnums.extra_deck_text("[font_size=20][font=%s](Hammer Waifu + Stone Basilisk)[/font][/font_size]
[i]Cost:[/i] Mill [code]2[/code]. [i](From your deck.)[/i]
[i]Effect:[/i] Target monster loses [code]1000[/code] [b]atk[/b]. [i](Until end of turn.)[/i]");
	
	return CardData.new(
		card, card_class,
		card_type, subtype, special_types,
		effects, effect_text,
		init_data,
		monster_data
	);
