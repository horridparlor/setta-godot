extends Node2D
class_name Zone

const CARD_MARGIN : int = 448;
const SPAWN_Y : int = System.Window_.y;
const SIDEWAYS_MARGIN_MULTIPLIER : float = 1.2;

var cards : Array;
var zone : CardEnums.Zone;
var zone_height : int;
var zone_width : int;
var zone_rotation : int;

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
	sort_card_position(zone_height, zone_width, GameplayEnums.OwningPlayer.YOU);
	if card and card.focus_state == GameplayEnums.FocusState.INTERACT:
		System.Children.focus(card, self);

func pull_card(card : GameplayCard, gameplay : Gameplay):
	cards.erase(card);
	reorder_cards(gameplay);
	card.zone = null;

func compare_x_position(cardA : GameplayCard, cardB : GameplayCard):
	return get_reorder_position(cardA) < get_reorder_position(cardB);

func get_reorder_position(card : GameplayCard):
	var direction : int = 1;
	return direction * card.position.x;

func sort_card_position(height : int, max_width : int, turn_player : GameplayEnums.OwningPlayer):
	if cards.is_empty():
		return;
	var card_count : int = cards.size();
	var card_margin : int = min(
		cards[0].Movement.get_base_scale(cards[0]).x * CARD_MARGIN,
		(max_width - GameplayCard.SIZE.x / 2) / (card_count - 1)
	);
	give_equal_positions(height, card_margin);

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
