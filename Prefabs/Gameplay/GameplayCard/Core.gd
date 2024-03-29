extends Node

static func initialize(card : GameplayCard, gameplay : Gameplay):
	card.artwork.texture = load(card.ARTWORK_LOAD_PREFIX + \
	System.String_.serialize(System.CardData.get_card_name(card.card_data)) + card.ARTWORK_LOAD_SUBFIX);
	update_visuals(card, gameplay);
	card.Core.activate_animations(card, gameplay);
	
static func update_visuals(card : GameplayCard, gameplay : Gameplay):
	var card_data : CardData = card.card_data;
	card.name_label.text = System.CardData.get_card_name(card_data);
	card.effect_text.text = card_data.effect_text;

static func activate_animations(card : GameplayCard, gameplay : Gameplay):
	var random : RandomNumberGenerator = gameplay.random;
	if gameplay.CardManager.can_be_played(card, gameplay) \
		or card.card_data.zone == CardEnums.Zone.FIELD:
			card.glow(random);
	else:
		card.shutter(random);
