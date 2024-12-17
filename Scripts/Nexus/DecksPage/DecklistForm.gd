extends DecklistForm

@onready var monster_block : DecklistBlock = $Blocks/MonsterBlock;
@onready var spell_block : DecklistBlock = $Blocks/SpellBlock;
@onready var trap_block : DecklistBlock = $Blocks/TrapBlock;
@onready var extra_block : DecklistBlock = $Blocks/ExtraBlock;
@onready var side_block : DecklistBlock = $Blocks/SideBlock;

func get_blocks() -> Array:
	return [
		monster_block,
		spell_block,
		trap_block,
		extra_block,
		side_block	
	];

func _ready() -> void:
	for block in get_blocks():
		block.activate_animations();

func toggle_card(card_data : CardData) -> void:
	var collection : Dictionary = get_collection_for_card(card_data);
	var card_id : int = card_data.card_id;
	if collection.has(card_id):
		collection.erase(card_id);
		card_counts.erase(card_id);
		despawn_slip(card_data);
	else:
		collection[card_id] = card_data;
		card_counts[card_id] = 1;
		spawn_slip(card_data);

func get_collection_for_card(card_data : CardData) -> Dictionary:
	if System.CardData.is_extra_deck(card_data):
		return extra_cards;
	match card_data.card_type:
		CardEnums.CardType.MONSTER:
			return monster_cards;
		CardEnums.CardType.SPELL:
			return spell_cards;
		CardEnums.CardType.TRAP:
			return trap_cards;
	return monster_cards;

func spawn_slip(card_data : CardData) -> void:
	var slip : DecklistSlip = System.Instance.load_child(DECKLIST_SLIP_PATH, self);
	slip.position = SLIP_STARTING_POSITION + Vector2(0, slips.size() * SLIP_MARGIN.y);
	slip.init(card_data);
	slip.alter_copies.connect(on_alter_copies);
	slips[card_data.card_id] = slip;
	update_min_y();

func update_min_y() -> void:
	min_y = (1 + slips.values().size()) * -SLIP_MARGIN.y;

func on_alter_copies(copies : int, card_data : CardData) -> void:
	if copies < 0:
		toggle_card(card_data);
	else:
		card_counts[card_data.card_id] = copies;
		slips[card_data.card_id].set_copies(copies);

func despawn_slip(card_data : CardData) -> void:
	var slip : DecklistSlip = slips[card_data.card_id];
	slips.erase(card_data.card_id);
	slip.queue_free();
	reorder_slips();
	update_min_y();
