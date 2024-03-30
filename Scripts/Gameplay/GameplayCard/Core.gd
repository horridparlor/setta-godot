extends Node

static func initialize(card : GameplayCard, gameplay : Gameplay) -> void:
	update_visuals(card, gameplay);
	activate_animations(card, gameplay);
	
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
	if card.glow_state == GameplayEnums.GlowState.GLOW:
		card.glow_node.glow(random);
	else:
		card.glow_node.shutter(random);
		
static func examine(card : GameplayCard, gameplay : Gameplay) -> void:
	close_modal(card, gameplay);
	render_modal(card, gameplay);

static func render_modal(card : GameplayCard, gameplay : Gameplay) -> void:
	card.modal = System.Instance.load_child(card.SUMMON_MODAL_PATH, card);
	card.modal.card_action.connect(card._on_modal_action);
	card.modal.position.y -= card.MODAL_OPTION_HEIGHT * card.modal.options;
	shutter_other_cards(card, gameplay);

static func glow_other_cards(card : GameplayCard, gameplay : Gameplay) -> void:
	change_other_cards_glow(GameplayEnums.GlowState.GLOW, card, gameplay);

static func shutter_other_cards(card : GameplayCard, gameplay : Gameplay) -> void:
	change_other_cards_glow(GameplayEnums.GlowState.SHUTTER, card, gameplay);

static func change_other_cards_glow(
	glow_state : GameplayEnums.GlowState,
	card : GameplayCard,
	gameplay : Gameplay
) -> void:
	var cards : Dictionary = gameplay.cards;
	for instance_id in cards:
		if instance_id != card.card_data.instance_id:
			var other_card : GameplayCard = cards[instance_id];
			other_card.Core.change_glow(glow_state, other_card, gameplay);

static func change_glow(
	glow_state : GameplayEnums.GlowState,
	card : GameplayCard,
	gameplay : Gameplay
) -> void:
	card.glow_state = glow_state;
	activate_animations(card, gameplay);

static func close_modal(card : GameplayCard, gameplay : Gameplay) -> void:
	if card.modal:
		card.modal.queue_free();
	card.modal = null;
	activate_animations(card, gameplay);
	glow_other_cards(card, gameplay);
