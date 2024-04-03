extends Node2D
class_name Zone

const CARD_MARGIN : int = 20;
const CARD_MARGIN_VECTOR : Vector2 = GameplayCard.SIZE + Vector2(CARD_MARGIN, CARD_MARGIN);
const SPAWN_Y : int = System.Window_.y;
const SIDEWAYS_MARGIN_MULTIPLIER : float = 1.2;
const CARDS_PER_SCROLL_ROW : int = 5;
const SCROLL_ROW_MARGINAL : float = (CARDS_PER_SCROLL_ROW - 1) * CARD_MARGIN_VECTOR.x / 2;
const SCROLL_ORIGO : Vector2 = Vector2(-SCROLL_ROW_MARGINAL, -CARD_MARGIN_VECTOR.y);

var cards : Array;
var zone : CardEnums.Zone;
var zone_height : int;
var zone_width : int;
var zone_rotation : int;
var zone_type : GameplayEnums.ZoneType = GameplayEnums.ZoneType.ROW;
var random : RandomNumberGenerator;

func count_cards() -> int:
	return cards.size();
	
func push_card(card : GameplayCard, gameplay : Gameplay):
	var previous_zone : Zone = card.zone;
	if previous_zone:
		take_over(card, previous_zone, gameplay);
	card.zone = self;
	cards.append(card);
	reorder_cards(gameplay);

func take_over(card : GameplayCard, previous_zone : Zone, gameplay : Gameplay):
	var card_data : CardData = card.card_data;
	move_card_data(card_data, previous_zone, gameplay);
	previous_zone.pull_card(card, gameplay);
	System.Children.move(card, previous_zone, self);

func move_card_data(card_data : CardData, previous_zone : Zone, gameplay : Gameplay) -> void:
	gameplay.game_state.move_card(
		card_data,
		ZoneData.new(previous_zone.zone, card_data.owning_player),
		ZoneData.new(zone, card_data.owning_player)
	);
	gameplay.update_player_stats();

func reorder_cards(gameplay : Gameplay):
	var card : GameplayCard = gameplay.focused_card;
	if random == null:
		random = gameplay.random;
	sort_card_position(GameplayEnums.OwningPlayer.YOU);
	if card and card.focus_state == GameplayEnums.FocusState.INTERACT:
		System.Children.focus(card, self);

func pull_card(card : GameplayCard, gameplay : Gameplay):
	cards.erase(card);
	reorder_cards(gameplay);
	card.zone = null;

func compare_x_position(cardA : GameplayCard, cardB : GameplayCard) -> bool:
	return cardA.position.x < cardB.position.x;

func compare_scroll_position(cardA : GameplayCard, cardB : GameplayCard) -> bool:
	return get_scroll_distance(cardA) < get_scroll_distance(cardB);

func get_scroll_distance(card : GameplayCard) -> float:
	var position : Vector2 = card.position;
	return position.distance_to(System.Random.item(cards, random).position);

func get_position_to_scroll_origo(card : GameplayCard) -> Vector2:
	return card.position.direction_to(SCROLL_ORIGO);

func sort_card_position(turn_player : GameplayEnums.OwningPlayer) -> void:
	if cards.is_empty():
		return;
	match zone_type:
		GameplayEnums.ZoneType.ROW:
			sort_algorithm_row(turn_player);
		GameplayEnums.ZoneType.SCROLL:
			sort_algorithm_scroll();

func sort_algorithm_scroll() -> void:
	var positioning_data : PositioningData = PositioningData.new(SCROLL_ORIGO);
	var count_of_rows : int = count_cards() / CARDS_PER_SCROLL_ROW + \
		(1 if count_cards() % CARDS_PER_SCROLL_ROW > 0 else 0);
	cards.sort_custom(compare_scroll_position);
	for card in cards:
		delegate_scroll_position(positioning_data, count_of_rows, card);

func delegate_scroll_position(
	positioning_data : PositioningData, count_of_rows : int,
	card : GameplayCard
) -> void:
	if positioning_data.index == positioning_data.hop_index:
		positioning_data.current_position.x = SCROLL_ORIGO.x \
			+ positioning_data.hops * CARD_MARGIN_VECTOR.x;
		positioning_data.current_position.y = SCROLL_ORIGO.y;
		positioning_data.hops += 1;
		if positioning_data.row_size < count_of_rows:
			positioning_data.hop_index += positioning_data.row_size;
			positioning_data.row_size += 1;
		elif positioning_data.hops < CARDS_PER_SCROLL_ROW:
			positioning_data.hop_index += positioning_data.row_size;
	else:
		positioning_data.current_position.x -= CARD_MARGIN_VECTOR.x;
		positioning_data.current_position.y += CARD_MARGIN_VECTOR.y;
		if positioning_data.current_position.y > SCROLL_ORIGO.y + (count_of_rows - 1) * CARD_MARGIN_VECTOR.y:
			positioning_data.fix_hops += 1;
			positioning_data.current_position.x += 2 * CARD_MARGIN_VECTOR.x;
			positioning_data.current_position.y -= positioning_data.fix_hops * CARD_MARGIN_VECTOR.y;
		elif positioning_data.fix_hops:
			positioning_data.current_position.x += CARD_MARGIN_VECTOR.x;
	card.Movement.set_origin(card.Movement.get_base_scale(card) \
		* positioning_data.current_position, card);
	positioning_data.index += 1;

func sort_algorithm_row(turn_player : GameplayEnums.OwningPlayer) -> void:
	var card_count : int = cards.size();
	var card_margin : int = min(
		cards[0].Movement.get_base_scale(cards[0]).x * CARD_MARGIN_VECTOR.x,
		(zone_width - GameplayCard.SIZE.x / 2) / (card_count - 1)
	);
	give_equal_positions(zone_height, card_margin);

func give_equal_positions(height : int, card_margin : int):
	var previous_cards : Array;
	var card_count : int = cards.size();
	var x : int = -card_margin *\
		(card_count / 2 if card_count % 2 == 1 else (card_count - 2) / 2 + 0.5);
	cards.sort_custom(compare_x_position);
	for card in cards:
		x = give_position(x, height, card_margin, card, previous_cards);
		
func give_position(
	x : int, height : int, card_margin : int,
	card : GameplayCard, previous_cards : Array
) -> int:
	var is_sideways : bool = card.Movement.is_sideways(card);
	card.Movement.set_origin(Vector2(x, height - get_rotation_fall(x)), card);
	if is_sideways:
		move_previous_left(previous_cards, card_margin);
	x += card_margin * \
		(SIDEWAYS_MARGIN_MULTIPLIER if is_sideways else 1);
	System.Children.focus(card, self);
	previous_cards.append(card);
	return x;

func get_rotation_fall(x : float) -> float:
	return -pow(get_card_rotation(x), 2);

func move_previous_left(cards : Array, card_margin : int) -> void:
	var card : GameplayCard;
	for c in cards:
		card = c;
		card.Movement.move_left(
			SIDEWAYS_MARGIN_MULTIPLIER * card_margin - card_margin,
			card
		);

func get_spawn_point() -> Vector2:
	return Vector2(0, SPAWN_Y);

func get_card_rotation(x : float) -> float:
	return (x / System.Window_.x) * zone_rotation;
