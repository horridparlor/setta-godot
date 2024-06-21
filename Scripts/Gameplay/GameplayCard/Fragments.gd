static func update_artwork(card : GameplayCard) -> void:
	load_artwork(card);
	update_attribute_sprite(card);
	update_layers_by_subtype(card);

static func load_artwork(card : GameplayCard) -> void:
	var image : Image = System.Image_.read(System.CardData.get_serialized_name(card.card_data));
	if image and System.Image_.is_valid(image):
		display_artwork(image, card);
	else:
		fetch_artwork(card);

static func fetch_artwork(card : GameplayCard) -> void:
	var card_data : CardData = card.card_data;
	var file_path : String = "%d/%d/%s%s" \
		% [
			card_data.card_id, card_data.owner_id,
			System.CardData.get_serialized_name(card_data),
			RequestEnums.get_webp_extension()
		];
	System.Server.request(RequestEnums.Operation.FETCH_ARTWORK, card, file_path);

static func update_attribute_sprite(card : GameplayCard) -> void:
	if card.card_data.card_class == CardEnums.Class.NONE:
		return;
	var attribute_name : String = System.CardData.get_attribute_name(card.card_data);
	card.attribute_sprite.texture = load(card.ATTRIBUTE_SPRITE_PREFIX + \
		attribute_name + SystemEnums.get_image_extension());
	card.attribute_name.text = attribute_name;

static func update_layers_by_subtype(card : GameplayCard) -> void:
	if card.card_data.subtype == CardEnums.CardSubtype.NONE:
		return;
	update_middle_frame(card);
	update_text_color(card);

static func update_text_color(card : GameplayCard) -> void:
	var text_color : Color = System.CardData.get_text_color_by_frame(card.card_data);
	card.name_label.add_theme_color_override("default_color", text_color);
	card.attribute_name.add_theme_color_override("font_color", text_color);

static func update_middle_frame(card : GameplayCard) -> void:
	System.Instance.load_child(
		card.MIDDLE_FRAME_PATH + \
		System.CardData.get_middle_frame_name(card.card_data) + \
		SystemEnums.get_node_extension(), card.middle_frame_layer
	);

static func update_monster_visuals(card : GameplayCard) -> void:
	var card_data : CardData = card.card_data;
	if System.CardData.is_monster(card_data):
		card.level_label.text = str(card_data.monster_data.level);
		card.atk_label.text = str(card_data.monster_data.atk);
		card.def_label.text = str(card_data.monster_data.def);
		card.monster_stats_layer.visible = true;
	else:
		card.monster_stats_layer.visible = false;

static func display_artwork(image : Image, card : GameplayCard, do_store : bool = false) -> void:
	card.artwork.texture = ImageTexture.new().create_from_image(image);
	if do_store:
		store_artwork(image, card);

static func store_artwork(image : Image, card : GameplayCard) -> void:
	if (!System.Image_.is_valid(image)):
		return;
	System.Image_.write(image, System.CardData.get_serialized_name(card.card_data));
