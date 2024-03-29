extends Node

static func initialize(card : GameplayCard, gameplay : Gameplay) -> void:
	update_visuals(card, gameplay);
	card.Core.activate_animations(card, gameplay);
	
static func update_visuals(card : GameplayCard, gameplay : Gameplay) -> void:
	var card_data : CardData = card.card_data;
	update_artwork(card, gameplay);
	card.name_label.text = System.CardData.get_card_name(card_data);
	card.effect_label.text = card_data.effect_text;
	update_monster_visuals(card, gameplay);

static func update_artwork(card : GameplayCard, gameplay : Gameplay):
	card.artwork.texture = load(card.ARTWORK_LOAD_PREFIX + \
	System.String_.serialize(System.CardData.get_card_name(card.card_data)) + card.ARTWORK_LOAD_SUBFIX);
	card.attribute_sprite.texture = load(card.ATTRIBUTE_SPRITE_PREFIX + \
	CardEnums.ClassName[card.card_data.card_class] + card.ATTRIBUTE_SPRITE_SUBFIX)

static func update_monster_visuals(card : GameplayCard, gameplay : Gameplay) -> void:
	var card_data : CardData = card.card_data;
	if (!card_data.card_type == CardEnums.CardType.MONSTER):
		return;
	card.level_label.text = str(card_data.monster_data.level);
	card.atk_label.text = str(card_data.monster_data.atk);
	card.def_label.text = str(card_data.monster_data.def);

static func activate_animations(card : GameplayCard, gameplay : Gameplay) -> void:
	var random : RandomNumberGenerator = gameplay.random;
	if gameplay.CardManager.can_be_played(card, gameplay) \
		or card.card_data.zone == CardEnums.Zone.FIELD:
			card.glow(random);
	else:
		card.shutter(random);
