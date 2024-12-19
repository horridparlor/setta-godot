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
		block.collapse.connect(on_collapse_block);
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
	for s in get_slips():
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

func on_collapse_block(block : NexusEnums.DecklistBlocks, value : bool) -> void:
	get_block_for_block_enum(block).toggle_collapsed(value);
	reorder_slips();

func toggle_card(card_data : CardData, do_reorder : bool, for_all_decks : bool) -> void:
	if for_all_decks && card_in_any_deck(card_data):
		despawn_card_from_all_decks(card_data, do_reorder);
	elif !for_all_decks && get_collection_for_card(card_data).has(card_data.card_id):
		despawn_card(card_data, do_reorder);
	else:
		spawn_card(card_data, get_max_copies_fit(card_data));

func despawn_card_from_all_decks(card_data : CardData, do_reorder : bool) -> void:
	var card_id : int = card_data.card_id;
	if main_deck_counts.has(card_id):
		despawn_card(main_deck_slips[card_id].card_data, do_reorder);
	if side_deck_counts.has(card_id):
		despawn_card(side_deck_slips[card_id].card_data, do_reorder);

func despawn_card(card_data : CardData, do_reorder : bool) -> void:
	get_collection_for_card(card_data).erase(card_data.card_id);
	update_card_count(card_data, 0);
	erase_count(card_data);
	despawn_slip(card_data, do_reorder);

func spawn_card(card_data : CardData, copies : int = 0) -> void:
	get_collection_for_card(card_data)[card_data.card_id] = card_data;
	update_card_count(card_data, copies);
	spawn_slip(card_data, copies);

func increment_card_count(card_data : CardData, increment : int) -> int:
	return update_card_count(card_data, get_count(card_data) + increment);

func get_block_enum_for_card(card_data : CardData) -> NexusEnums.DecklistBlocks:
	return get_block_enum_for_block(get_block_for_card(card_data));

func update_card_count(card_data : CardData, copies : int) -> int:
	var block : NexusEnums.DecklistBlocks = get_block_enum_for_card(card_data);
	var counts : Dictionary = get_counts(card_data);
	var original_copies : int = get_count(card_data);
	counts[card_data.card_id] = copies;
	collection_counts[block] += copies - original_copies;
	if card_data.is_ace:
		toggle_ace(card_data, copies > 0 || (!original_copies && has_competing_ace(card_data)));
	if System.CardData.is_deck_master(card_data):
		emit_signal("deckmaster_counts_changed");
	return copies;

func get_collection_for_card(card_data : CardData) -> Dictionary:
	return get_collection_for_block(get_block_for_card(card_data));

func spawn_slip(card_data : CardData, card_count : int) -> void:
	var slip : DecklistSlip = System.Instance.load_child(DECKLIST_SLIP_PATH, self);
	slip.position = SLIP_STARTING_POSITION + Vector2(0, get_slips().size() * SLIP_MARGIN.y);
	slip.init(card_data, card_count);
	slip.alter_copies.connect(on_alter_copies);
	slip.sidedeck_card.connect(on_sidedeck_card);
	slip.reference_card.connect(on_reference_card);
	put_slip(card_data, slip);
	slip.toggle_active();
	reorder_slips();
	if !System.CardData.is_monster(card_data):
		return;
	slip.modulate_icons(int(is_modulating_in_level), int(is_modulating_in_attribute));
	count_of_monsters += 1;
	if !has_slips_to_modulate:
		has_slips_to_modulate = true;
		reset_icon_modulation(true);
	if referenced_card && card_data.card_id == referenced_card.card_id:
		slip.full_shutter();

func on_reference_card(card_data : CardData) -> void:
	emit_signal("reference_card", card_data);

func on_sidedeck_card(card_data : CardData) -> void:
	var is_from_main_deck : bool = System.CardData.in_main_deck(card_data);
	var is_in_main_deck : bool = is_from_main_deck || main_deck_counts.has(card_data.card_id);
	var is_in_side_deck : bool = !is_from_main_deck || side_deck_counts.has(card_data.card_id);
	var copies_to_move : int = 1;
	if is_from_main_deck:
		if !can_add_to_side_deck(card_data):
				copies_to_move = 0;
		if !is_in_side_deck:
			spawn_to_side_deck(card_data);
		move_copies_to_side_deck(card_data, copies_to_move);
	else:
		if !can_add_to_main_deck(card_data):
				copies_to_move = 0;
		if !is_in_main_deck:
			spawn_to_main_deck(card_data);
		move_copies_to_main_deck(card_data, copies_to_move);

func spawn_to_main_deck(card_data : CardData) -> void:
	var new_data : CardData = card_data.copy();
	new_data.move_to_main_deck();
	spawn_card(new_data);

func spawn_to_side_deck(card_data : CardData) -> void:
	var new_data : CardData = card_data.copy();
	new_data.move_to_side_deck();
	spawn_card(new_data);

func move_copies_to_main_deck(card_data : CardData, copies : int) -> void:
	move_between_decks(card_data, copies, -1);

func move_copies_to_side_deck(card_data : CardData, copies : int) -> void:
	move_between_decks(card_data, copies);

func move_between_decks(card_data : CardData, copies_to_move : int, direction : int = 1) -> void:
	var card_id : int = card_data.card_id;
	var main_deck_slip : DecklistSlip = main_deck_slips[card_id];
	var side_deck_slip : DecklistSlip = side_deck_slips[card_id];
	var from_slip : DecklistSlip = main_deck_slip if direction > 0 else side_deck_slip;
	var to_slip : DecklistSlip = side_deck_slip if direction > 0 else main_deck_slip;
	if get_count(from_slip.card_data):
		from_slip.set_copies(increment_card_count(from_slip.card_data, -copies_to_move));
		to_slip.set_copies(increment_card_count(to_slip.card_data, copies_to_move));
	if from_slip.copies == 0:
		despawn_card(from_slip.card_data, false);
	reorder_slips();

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
	var card_count : int;
	var is_side_deck : bool;
	var cards_collapsed : int;
	active_blocks = 0;
	for b in get_blocks():
		block = b;
		card_count = 0;
		is_side_deck = block.block == NexusEnums.DecklistBlocks.SIDE;
		cards = get_collection_for_block(block);
		has_cards = !cards.is_empty();
		block.visible = has_cards;
		if !has_cards:
			block.toggle_collapsed();
			continue;
		active_blocks += 1;
		block.position.y = current_y + cards_above * SLIP_MARGIN.y;
		for card_data in cards.values():
			card_count += get_count(card_data);
			get_slip(card_data).visible = block.is_collapsed;
			if !block.is_collapsed:
				cards_collapsed += 1;
				continue;
			get_slip(card_data).position.y += current_y - cards_collapsed * SLIP_MARGIN.y;
			cards_above += 1;
		block.set_count(card_count);
		current_y += BLOCK_MARGIN.y;

func update_min_y() -> void:
	min_y = (1 + get_slips().size()) * -SLIP_MARGIN.y + max(0, active_blocks - 1) * -BLOCK_MARGIN.y;

func on_alter_copies(copies : int, card_data : CardData) -> void:
	if copies < 0:
		emit_signal("request_toggle_card", card_data);
	else:
		if alter_card_copies(card_data, copies) && in_both_decks(card_data):
			alter_copies_in_other_deck(card_data, copies);

func alter_copies_in_other_deck(card_data : CardData, copies : int) -> void:
	var in_main_deck : bool = System.CardData.in_main_deck(card_data);
	var main_deck_slip : DecklistSlip = main_deck_slips[card_data.card_id];
	var side_deck_slip : DecklistSlip = side_deck_slips[card_data.card_id];
	var other_deck_slip : DecklistSlip = side_deck_slip if in_main_deck else main_deck_slip;
	var extra_copies : int = max(0, (get_count(main_deck_slip.card_data) + get_count(side_deck_slip.card_data)) - card_data.max_copies);
	if !extra_copies:
		return;
	if !other_deck_slip.set_copies(increment_card_count(other_deck_slip.card_data, -extra_copies)):
		despawn_card(other_deck_slip.card_data, true);

func alter_card_copies(card_data : CardData, copies : int) -> int:
	var change : int = copies - get_count(card_data);
	var vacant_change : int;
	if change > 0:
		vacant_change = min(change, get_deck_room_for_card(card_data));
		copies += vacant_change - change;
		change = vacant_change;
	update_card_count(card_data, copies)
	get_slip(card_data).set_copies(copies);
	get_block_for_card(card_data).increment_count(change);
	return change

func despawn_slip(card_data : CardData, do_reorder : bool) -> void:
	var slip : DecklistSlip = get_slip(card_data);
	erase_slip(card_data);
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
