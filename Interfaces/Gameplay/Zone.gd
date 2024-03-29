extends Node2D
class_name Zone

const ROTATION_SPEED : int = 360;
const CARD_MARGIN : int = 448;
const OWNER_MARGIN : int = 130;
const TURN_PLAYER_MARGIN : int = 40;

var cards : Array;
var goal_rotation : int;
var is_rotating : bool;
var licked_card : GameplayCard;
var orbiting_card : GameplayCard;
var zone : CardEnums.Zone;

func count_cards():
	return cards.size();
	
func push_card(card : GameplayCard, gameplay : Gameplay):
	var previous_zone : Zone = card.zone;
	if previous_zone:
		take_over(card, previous_zone, gameplay);
	card.zone = self;
	cards.append(card);
	reorder_cards(gameplay);

func take_over(card : GameplayCard, previous_zone : Zone, gameplay : Gameplay):
	previous_zone.pull_card(card, gameplay);
	System.Children.move(card, previous_zone, self);
	
func reorder_cards(gameplay : Gameplay):
	pass;

func pull_card(card : GameplayCard, gameplay : Gameplay):
	cards.erase(card);
	reorder_cards(gameplay);
	card.zone = null;
	
func get_other_cards(card : GameplayCard):
	var other_cards = cards.duplicate();
	other_cards.erase(card);
	return other_cards;

func turn_to_player(owning_player : GameplayEnums.OwningPlayer):
	pass;

func compare_x_position(cardA : GameplayCard, cardB : GameplayCard):
	return get_reorder_position(cardA) < get_reorder_position(cardB);

func get_reorder_position(card : GameplayCard):
	var direction : int = -1 if card == licked_card && \
		card.card_data.owning_player == GameplayEnums.OwningPlayer.PLAYER_2 else 1;
	return direction * card.position.x;

func sort_card_position(height : int, turn_player : GameplayEnums.OwningPlayer):
	if cards.is_empty():
		return;
	var card_margin : int = cards[0].Movement.get_base_scale(cards[0]).x * CARD_MARGIN;
	var player_1_cards : Array = [];
	var player_2_cards : Array = [];
	var turn_player_margin : int = TURN_PLAYER_MARGIN \
		if turn_player == GameplayEnums.OwningPlayer.PLAYER_2 else -TURN_PLAYER_MARGIN;
	get_cards_by_player(player_1_cards, player_2_cards);
	if player_1_cards.is_empty() || player_2_cards.is_empty():
		give_equal_positions(player_1_cards + player_2_cards, height, card_margin);
	else:
		give_equal_positions(player_1_cards, height + OWNER_MARGIN + turn_player_margin, card_margin);
		give_equal_positions(player_2_cards, height - OWNER_MARGIN + turn_player_margin, card_margin);

func give_equal_positions(cards_to_position : Array, height : int, card_margin : int):
	var count : int = cards_to_position.size();
	var x : int = -card_margin *\
		(count / 2 if count % 2 == 1 else (count - 2) / 2 + 0.5);
	cards_to_position.sort_custom(compare_x_position);
	for card in cards_to_position:
		card.Movement.set_origin(Vector2(x, height), card);
		x += card_margin;

func get_owned_by_player_1(card : GameplayCard):
	return GameplayEnums.OwningPlayer.PLAYER_1 == GameplayEnums.OwningPlayer.PLAYER_1;

func get_cards_by_player(player_1_cards : Array, player_2_cards : Array):
	var cards_to_position : Array = cards + ([] if licked_card == null else [licked_card]);
	cards_to_position.erase(orbiting_card);
	for card in cards_to_position:
		if get_owned_by_player_1(card):
			player_1_cards.append(card);
		else:
			player_2_cards.append(card);

func lick_card(card : GameplayCard, gameplay : Gameplay):
	if card in cards:
		orbiting_card = null;
	else:
		licked_card = card;
		card.zone.orbiting_card = card;
	reorder_cards(gameplay);
