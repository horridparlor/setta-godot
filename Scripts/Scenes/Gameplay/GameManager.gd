static func start_game(gameplay : Gameplay) -> void:
	render_hand(gameplay);
	start_turn(gameplay);
	gameplay.Widgets.control_showcases_glow(GameplayEnums.GlowState.GLOW, gameplay);

static func start_turn(gameplay : Gameplay) -> void:
	gameplay.game_state.draw_phase();
	render_hand(gameplay);

static func render_hand(gameplay : Gameplay) -> void:
	render_cards(gameplay.game_state.you.cards_in_hand, gameplay.hand, gameplay);

static func render_cards(cards : Array, zone : Zone, gameplay : Gameplay) -> void:
	for card in cards:
		render_card(card, zone, gameplay);

static func render_card(card_data : CardData, zone : Zone, gameplay : Gameplay) -> void:
	var cards : Dictionary = gameplay.cards;
	var instance_id : int = card_data.instance_id;
	var card : GameplayCard = cards[instance_id] \
		if cards.has(instance_id) \
		else instance_card(card_data, zone, gameplay);
	zone.push_card(card, gameplay);
	card.Core.initialize(card, gameplay);
	card.Core.set_initial_scale(zone.zone, card);

static func instance_card(card_data : CardData, zone : Zone, gameplay : Gameplay) -> GameplayCard:
	var card : GameplayCard = System.Instance.load_child(SystemEnums.get_card_path(), zone);
	card.pressed.connect(gameplay._on_card_clicked);
	card.released.connect(gameplay._on_card_released);
	card.card_action.connect(gameplay._on_card_action);
	card.card_data = card_data;
	card.random = gameplay.random;
	gameplay.cards[card_data.instance_id] = card;
	card.position = zone.get_spawn_point();
	return card;

static func delete_cards(cards : Array, zone : Zone, gameplay : Gameplay) -> void:
	for card in cards:
		delete_card(card, zone, gameplay);

static func delete_card(card_data : CardData, zone : Zone, gameplay : Gameplay) -> void:
	gameplay.cards[card_data.instance_id].despawn(gameplay);
