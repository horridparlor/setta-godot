static func update_artwork(card : GameplayCard):
	card.artwork.texture = load(card.ARTWORK_LOAD_PREFIX + \
		System.String_.serialize(System.CardData.get_card_name(card.card_data)) + \
		SystemEnums.get_image_extension());
	update_attribute_sprite(card);
	update_layers_by_subtype(card);

static func update_attribute_sprite(card : GameplayCard) -> void:
	if card.card_data.card_class == CardEnums.Class.NONE:
		return;
	card.attribute_sprite.texture = load(card.ATTRIBUTE_SPRITE_PREFIX + \
		CardEnums.ClassName[card.card_data.card_class] + SystemEnums.get_image_extension())

static func update_layers_by_subtype(card : GameplayCard) -> void:
	if card.card_data.subtype == CardEnums.CardSubtype.NONE:
		return;
	update_middle_frame(card);

static func update_middle_frame(card : GameplayCard) -> void:
	System.Instance.load_child(
		card.MIDDLE_FRAME_PATH + \
		CardEnums.subtype_to_string[card.card_data.subtype] + \
		SystemEnums.get_node_extension(), card.middle_frame_layer
	);

static func update_monster_visuals(card : GameplayCard) -> void:
	var card_data : CardData = card.card_data;
	if (!card_data.card_type == CardEnums.CardType.MONSTER):
		return;
	card.level_label.text = str(card_data.monster_data.level);
	card.atk_label.text = str(card_data.monster_data.atk);
	card.def_label.text = str(card_data.monster_data.def);
