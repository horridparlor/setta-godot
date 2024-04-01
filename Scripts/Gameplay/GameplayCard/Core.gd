extends Node

static func initialize(card : GameplayCard) -> void:
	update_visuals(card);
	activate_animations(card);
	
static func update_visuals(card : GameplayCard) -> void:
	var card_data : CardData = card.card_data;
	update_artwork(card);
	card.name_label.text = System.CardData.get_card_name(card_data);
	card.effect_label.text = card_data.effect_text;
	update_monster_visuals(card);

static func update_artwork(card : GameplayCard):
	var subfix : String = SystemEnums.get_image_extension();
	card.artwork.texture = load(card.ARTWORK_LOAD_PREFIX + \
		System.String_.serialize(System.CardData.get_card_name(card.card_data)) + \
		subfix);
	card.attribute_sprite.texture = load(card.ATTRIBUTE_SPRITE_PREFIX + \
		CardEnums.ClassName[card.card_data.card_class] + subfix)

static func update_monster_visuals(card : GameplayCard) -> void:
	var card_data : CardData = card.card_data;
	if (!card_data.card_type == CardEnums.CardType.MONSTER):
		return;
	card.level_label.text = str(card_data.monster_data.level);
	card.atk_label.text = str(card_data.monster_data.atk);
	card.def_label.text = str(card_data.monster_data.def);

static func activate_animations(card : GameplayCard) -> void:
	if card.glow_state == GameplayEnums.GlowState.GLOW:
		card.glow_node.glow(card.random);
	else:
		card.glow_node.shutter(card.random);

static func control_glow(
	glow_state : GameplayEnums.GlowState,
	card : GameplayCard
) -> void:
	card.glow_state = glow_state;
	activate_animations(card);
