static func update_artwork(card : GameplayCard) -> void:
	load_artwork(card);
	update_attribute_sprite(card);
	update_layers_by_subtype(card);

static func load_artwork(card : GameplayCard) -> void:
	toggle_loading_icon(card, false);
	var image : Image = System.Image_.read(System.CardData.get_serialized_name(card.card_data));
	if image and System.Image_.is_valid(image):
		display_artwork(image, card);
	else:
		update_ace_badge(card, false);
		card.artwork.texture = null;
		fetch_artwork(card);

static func fetch_artwork(card : GameplayCard) -> void:
	if card.artwork.texture == null:
		toggle_loading_icon(card);
	print(get_artwork_fetch_path(card));
	System.Server.request(RequestEnums.Operation.FETCH_ARTWORK, {}, card, get_artwork_fetch_path(card), {
		"card_name": System.CardData.get_serialized_name(card.card_data)
	});

static func get_artwork_fetch_path(card : GameplayCard) -> String:
	var card_data : CardData = card.card_data;
	return "%d/%d/%s%s" \
		% [
			card_data.card_id, card_data.owner_id,
			System.CardData.get_serialized_name(card_data),
			RequestEnums.get_webp_extension()
		];

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
	var is_deck_master : bool = System.CardData.is_deck_master(card_data);
	card.level_label.text = str(card_data.monster_data.level);
	if System.CardData.is_monster(card_data):
		card.level_sprite.texture = load(card.DECK_MASTER_LEVEL_FRAME_PATH if is_deck_master else card.LEVEL_FRAME_PATH);
		card.atk_label.text = str(card_data.monster_data.atk);
		card.def_label.text = str(card_data.monster_data.def);
		card.monster_stats_layer.visible = true;
		if is_deck_master:
			card.deck_master_primary_class_sprite.texture = load(
				card.DECK_MASTER_ATTRIBUTE_SPRITE_PREFIX + CardEnums.ClassName[card.card_data.card_class] + SystemEnums.get_image_extension());
			if card.card_data.secondary_class != CardEnums.Class.NONE:
				card.deck_master_secondary_class_sprite.texture = load(
					card.DECK_MASTER_ATTRIBUTE_SPRITE_PREFIX + CardEnums.ClassName[card.card_data.secondary_class] + SystemEnums.get_image_extension());
			else:
				card.deck_master_primary_class_sprite.position.x = 0;
		else:
			card.deck_master_primary_class_sprite.texture = null;
			card.deck_master_secondary_class_sprite.texture = null;
	else:
		card.monster_stats_layer.visible = false;

static func display_artwork(image : Image, card : GameplayCard, do_store : bool = false, request : OperationRequest = null) -> void:
	toggle_loading_icon(card, false);
	if do_store:
		store_artwork(image, request);
	if request and request.file_path != get_artwork_fetch_path(card):
		fetch_artwork(card);
		return;
	update_ace_badge(card);
	card.artwork.texture = ImageTexture.new().create_from_image(image);

static func store_artwork(image : Image, request : OperationRequest) -> void:
	if (!System.Image_.is_valid(image)):
		return;
	System.Image_.write(image, request.local_data.card_name);

static func update_ace_badge(card : GameplayCard, overwrite = null) -> void:
	card.ace_badge.visible = overwrite if overwrite != null else card.card_data.is_ace;

static func toggle_loading_icon(card : GameplayCard, value : bool = true) -> void:
	if !value:
		if card.loading_icon && is_instance_valid(card.loading_icon):
			card.loading_icon.queue_free();
		return;
	card.loading_icon = System.Instance.load_child(card.LOADING_ICON_PATH, card);
	card.loading_icon.position = card.LOADING_ICON_POSITION;
	card.loading_icon.init(SystemEnums.IconSize.SMALL);
	card.artwork.texture = null;
