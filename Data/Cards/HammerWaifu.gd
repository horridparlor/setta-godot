extends Node

static func out(random : RandomNumberGenerator):
	var card : CardEnums.Card = CardEnums.Card.HAMMER_WAIFU;
	var card_type : CardEnums.CardType = CardEnums.CardType.MONSTER;
	var subtype : CardEnums.CardSubtype = CardEnums.CardSubtype.EFFECT;
	var effects : Array = [
	];
	var effect_text : String = "[i]Cost:[/i] Discard a card. [i](Hand.)[/i]
[i]Effect:[/i] Target monster loses [code]200[/code] [b]atk[/b]. [i](All stat changes only last until the end of turn.)[/i]";
	
	return CardData.new(card, card_type, subtype, effects, effect_text, random);
