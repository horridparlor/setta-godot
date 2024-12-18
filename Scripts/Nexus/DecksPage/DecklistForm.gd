extends DecklistForm

@onready var deckmaster_block : DecklistBlock = $Blocks/DeckMasterBlock;
@onready var monster_block : DecklistBlock = $Blocks/MonsterBlock;
@onready var spell_block : DecklistBlock = $Blocks/SpellBlock;
@onready var trap_block : DecklistBlock = $Blocks/TrapBlock;
@onready var extra_block : DecklistBlock = $Blocks/ExtraBlock;
@onready var side_block : DecklistBlock = $Blocks/SideBlock;

@onready var modulation_timer : Timer = $Timers/ModulationTimer;

func get_blocks() -> Array:
	return [
		deckmaster_block,
		monster_block,
		spell_block,
		trap_block,
		extra_block,
		side_block	
	];

func _ready() -> void:
	var block : DecklistBlock;
	for b in get_blocks():
		block = b;
		block.activate_animations();
		block.init(get_block_enum_for_block(block));
		block.trash.connect(on_empty_block);
	modulation_timer.wait_time = MODULATION_WAIT;
	reset_icon_modulation();

func _physics_process(delta : float) -> void:
	if is_modulating_icons:
		modulate_icons(delta);

func modulate_icons(delta : float) -> void:
	var level_modulation : float;
	var attribute_modulation : float;
	var slip : DecklistSlip;
	modulation_charge += MODULATION_SPEED * delta;
	level_modulation = get_icon_modulation(is_modulating_in_level, modulation_charge);
	attribute_modulation = get_icon_modulation(is_modulating_in_attribute, modulation_charge);
	for s in slips.values():
		slip = s;
		if slip.is_modulating_icons:
			slip.modulate_icons(level_modulation, attribute_modulation);
	if modulation_charge >= 1:
		is_modulating_icons = false;
		modulation_timer.start();

func get_icon_modulation(is_modulating_in : bool, modulation_charge : float) -> float:
	if is_modulating_in:
		return modulation_charge;
	else:
		return 1 - modulation_charge;

func reset_icon_modulation(do_start : bool = false) -> void:
	is_modulating_in_level = false;
	is_modulating_in_attribute = true;
	if do_start:
		modulation_timer.start();

func on_empty_block(block : NexusEnums.DecklistBlocks) -> void:
	var collection : Dictionary = get_collection_for_block(get_block_for_block_enum(block));
	for card in collection.values():
		on_alter_copies(-1, card);

func toggle_card(card_data : CardData, do_reorder : bool) -> void:
	var collection : Dictionary = get_collection_for_card(card_data);
	var card_id : int = card_data.card_id;
	if collection.has(card_id):
		collection.erase(card_id);
		update_card_count(card_data, 0);
		card_counts.erase(card_id);
		despawn_slip(card_data, do_reorder);
	else:
		collection[card_id] = card_data;
		update_card_count(card_data, System.CardData.get_max_copies(card_data));
		spawn_slip(card_data);

func update_card_count(card_data : CardData, copies : int) -> void:
	var block : NexusEnums.DecklistBlocks = get_block_enum_for_block(get_block_for_card(card_data));
	var original_copies : int = 0 if !card_counts.has(card_data.card_id) else card_counts[card_data.card_id];
	card_counts[card_data.card_id] = copies;
	collection_counts[block] += copies - original_copies;
	if System.CardData.is_deck_master(card_data):
		emit_signal("deckmaster_counts_changed");

func get_collection_for_card(card_data : CardData) -> Dictionary:
	return get_collection_for_block(get_block_for_card(card_data));

func spawn_slip(card_data : CardData) -> void:
	var slip : DecklistSlip = System.Instance.load_child(DECKLIST_SLIP_PATH, self);
	slip.position = SLIP_STARTING_POSITION + Vector2(0, slips.size() * SLIP_MARGIN.y);
	slip.init(card_data);
	slip.alter_copies.connect(on_alter_copies);
	slip.sidedeck_card.connect(on_sidedeck_card);
	slips[card_data.card_id] = slip;
	slip.toggle_active();
	reorder_slips();
	if !System.CardData.is_monster(card_data):
		return;
	slip.modulate_icons(int(is_modulating_in_level), int(is_modulating_in_attribute));
	count_of_monsters += 1;
	if !has_slips_to_modulate:
		has_slips_to_modulate = true;
		reset_icon_modulation(true);

func on_sidedeck_card(card_data : CardData) -> void:
	if System.CardData.in_side_deck(card_data):
		return_to_main_deck(card_data);
	else:
		add_to_side_deck(card_data);
	slips[card_data.card_id].update_count_icons();
	reorder_slips();

func return_to_main_deck(card_data : CardData) -> void:
	var collection : Dictionary;
	side_cards.erase(card_data.card_id);
	card_data.move_to_main_deck();
	collection = get_collection_for_card(card_data);
	collection[card_data.card_id] = card_data;

func add_to_side_deck(card_data : CardData) -> void:
	var collection : Dictionary = get_collection_for_card(card_data);
	collection.erase(card_data.card_id);
	card_data.move_to_side_deck();
	side_cards[card_data.card_id] = card_data;

func get_collection_for_block(block : DecklistBlock) -> Dictionary:
	match block:
		deckmaster_block:
			return deckmaster_cards;
		monster_block:
			return monster_cards;
		spell_block:
			return spell_cards;
		trap_block:
			return trap_cards;
		extra_block:
			return extra_cards;
		side_block:
			return side_cards;	
	return monster_cards;

func get_block_for_card(card_data : CardData) -> DecklistBlock:
	if System.CardData.in_side_deck(card_data):
		return side_block;
	if System.CardData.is_extra_deck(card_data):
		return extra_block;
	match card_data.card_type:
		CardEnums.CardType.MONSTER:
			if System.CardData.is_deck_master(card_data):
				return deckmaster_block;
			return monster_block;
		CardEnums.CardType.SPELL:
			return spell_block;
		CardEnums.CardType.TRAP:
			return trap_block;
	return monster_block;

func get_block_enum_for_block(block : DecklistBlock) -> NexusEnums.DecklistBlocks:
	match block:
		deckmaster_block:
			return NexusEnums.DecklistBlocks.DECK_MASTER;
		monster_block:
			return NexusEnums.DecklistBlocks.MONSTER;
		spell_block:
			return NexusEnums.DecklistBlocks.SPELL;
		trap_block:
			return NexusEnums.DecklistBlocks.TRAP;
		extra_block:
			return NexusEnums.DecklistBlocks.EXTRA;
		side_block:
			return NexusEnums.DecklistBlocks.SIDE;	
	return NexusEnums.DecklistBlocks.MONSTER;

func get_block_for_block_enum(block : NexusEnums.DecklistBlocks) -> DecklistBlock:
	match block:
		NexusEnums.DecklistBlocks.DECK_MASTER:
			return deckmaster_block;
		NexusEnums.DecklistBlocks.MONSTER:
			return monster_block;
		NexusEnums.DecklistBlocks.SPELL:
			return spell_block;
		NexusEnums.DecklistBlocks.TRAP:
			return trap_block;
		NexusEnums.DecklistBlocks.EXTRA:
			return extra_block;
		NexusEnums.DecklistBlocks.SIDE:
			return side_block;
	return monster_block;
	
func update_blocks() -> void:
	var current_y : float;
	var cards_above : int;
	var has_cards : bool;
	var cards : Dictionary;
	var block : DecklistBlock;
	var card_count;
	active_blocks = 0;
	for b in get_blocks():
		block = b;
		card_count = 0;
		cards = get_collection_for_block(block);
		has_cards = !cards.is_empty();
		block.visible = has_cards;
		if !has_cards:
			continue;
		active_blocks += 1;
		block.position.y = current_y + cards_above * SLIP_MARGIN.y;
		for card_id in cards.keys():
			slips[card_id].position.y += current_y;
			cards_above += 1;
			card_count += card_counts[card_id];
		block.set_count(card_count);
		current_y += BLOCK_MARGIN.y;

func update_min_y() -> void:
	min_y = (1 + slips.values().size()) * -SLIP_MARGIN.y + max(0, active_blocks - 1) * -BLOCK_MARGIN.y;

func on_alter_copies(copies : int, card_data : CardData) -> void:
	var change : int;
	if copies < 0:
		emit_signal("request_toggle_card", card_data);
	else:
		change = copies - card_counts[card_data.card_id];
		update_card_count(card_data, copies)
		slips[card_data.card_id].set_copies(copies);
		get_block_for_card(card_data).increment_count(change);

func despawn_slip(card_data : CardData, do_reorder : bool) -> void:
	var slip : DecklistSlip = slips[card_data.card_id];
	slips.erase(card_data.card_id);
	slip.queue_free();
	if do_reorder:
		reorder_slips();
	if !has_slips_to_modulate || !System.CardData.is_monster(card_data):
		return;
	count_of_monsters -= 1;
	if count_of_monsters == 0:
		modulation_timer.stop();
		has_slips_to_modulate = false;
		is_modulating_icons = false;
		reset_icon_modulation();
			

func update_blocks_active() -> void:
	var block : DecklistBlock;
	for b in get_blocks():
		block = b;
		block.toggle_active(is_active);

func _on_modulation_timer_timeout() -> void:
	modulation_timer.stop();
	is_modulating_in_level = !is_modulating_in_level;
	is_modulating_in_attribute = !is_modulating_in_attribute;
	modulation_charge = 0;
	is_modulating_icons = true;
