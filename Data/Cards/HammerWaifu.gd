extends Node

static func out(init_data : CardInitData):
	var card : CardEnums.Card = CardEnums.Card.HAMMER_WAIFU;
	var card_class : CardEnums.Class = CardEnums.Class.DRAGON;
	var card_type : CardEnums.CardType = CardEnums.CardType.MONSTER;
	var subtype : CardEnums.CardSubtype = CardEnums.CardSubtype.EFFECT;
	var special_types : SpecialTypes = SpecialTypes.new();
	
	var level : int = 3;
	var atk : int = 1200;
	var def : int = 0;
	var monster_data : MonsterData = MonsterData.new(level, atk, def);
	
	var effect_cost : EffectCost = EffectCost.new(
		EffectEnums.CostType.DISCARD,
		EffectTarget.new(EffectEnums.TargetType.DEFAULT),
		1
	);
	var effect_effect : EffectEffect = EffectEffect.new(
		EffectEnums.EffectType.ATK_LOSE,
		EffectTarget.new(EffectEnums.TargetType.TARGET_MONSTER),
		200
	);
	var effects : CardEffects = CardEffects.new(effect_cost, effect_effect);
	var effect_text : String = "[i]Cost:[/i] Discard a card. [i](Hand.)[/i]
[i]Effect:[/i] Target monster loses [code]200[/code] [b]atk[/b]. [i](All stat changes only last until the end of turn.)[/i]";
	
	return CardData.new(
		card, card_class,
		card_type, subtype, special_types,
		effects, effect_text,
		init_data,
		monster_data
	);
