extends Node
class_name GameState

var you : PlayerData;
var opponent : PlayerData;

var turn_player : GameplayEnums.OwningPlayer = GameplayEnums.OwningPlayer.YOU;
var turn_number : int = 0;
var turn_phase : GameplayEnums.TurnPhase = GameplayEnums.TurnPhase.NONE;

func _init(
	you_ : PlayerData,
	opponent_ : PlayerData,
	random : RandomNumberGenerator
) -> void:
	you = you_;
	opponent = opponent_;
	#randomize_starting_player(random);

func randomize_starting_player(random : RandomNumberGenerator) -> void:
	turn_player = System.Random.item(GameplayEnums.get_owning_players(), random);

func get_players() -> Array:
	return [you, opponent];

func active_player() -> PlayerData:
	return get_player(turn_player);

func other_player() -> PlayerData:
	return you if turn_player == GameplayEnums.OwningPlayer.OPPONENT else opponent;

func draw_phase() -> void:
	turn_phase = GameplayEnums.TurnPhase.DRAW_PHASE;
	active_player().commit_draw_phase();

func get_player(owning_player : GameplayEnums.OwningPlayer) -> PlayerData:
	return you if owning_player == GameplayEnums.OwningPlayer.YOU else opponent;

func move_card(
	card : CardData, previous_zone : ZoneData, next_zone : ZoneData
) -> void:
	get_player(previous_zone.owning_player).pull_card(card, previous_zone.zone);
	get_player(next_zone.owning_player).push_card(card, next_zone.zone);

func can_play_card(card : CardData, owning_player : GameplayEnums.OwningPlayer) -> bool:
	return get_player(owning_player).can_play_card(card);

func has_materials(card : CardData, owning_player : GameplayEnums.OwningPlayer) -> bool:
	return get_player(owning_player).has_materials(card);
