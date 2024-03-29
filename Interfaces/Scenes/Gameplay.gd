extends Node2D
class_name Gameplay

const CARD_PATH : String = "res://Prefabs/Gameplay/GameplayCard.tscn";
const TRIGGERS_ROUND_WAIT_TIME : float = 0.8;
const TRIGGERS_TURN_WAIT_TIME : float = 0.7;
const GAME_END_WAIT_TIME : float = 2.6;

var cards : Array;
var focused_card : GameplayCard;
var random : RandomNumberGenerator = RandomNumberGenerator.new();
var turn_player : PlayerData;
var starting_player : PlayerData;
var turn_phase : GameplayEnums.TurnPhase = GameplayEnums.TurnPhase.DRAW_PHASE;
var player_1 : PlayerData;
var player_2 : PlayerData;
var negated_subtypes : Dictionary;

func get_players():
	return [player_1, player_2];

func get_starting_player():
	starting_player = System.Random.item(get_players(), random);
	return starting_player;

func other_player():
	return player_1 if turn_player == player_2 else player_2;

func get_cards_on_field():
	return player_1.cards_on_field + player_2.cards_on_field;
