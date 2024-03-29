extends Node

const ROTATION_PLAYER_1 : int = 360;
const ROTATION_PLAYER_2 : int = 180;

enum TargetPlayer {
	BOTH,
	OPPONENT,
	SELF,
}

enum OwningPlayer {
	PLAYER_1,
	PLAYER_2,
}

enum TurnPhase {
	BETWEEN_PHASES,
	DRAW_PHASE,
	MAIN_PHASE,
	FINAL_PHASE
}

enum IsMoving {
	IN,
	NOT,
	OUT,
}

enum Speed {
	FAST,
	SLOW,
}

static func get_rotation(owning_player : OwningPlayer):
	match owning_player:
		OwningPlayer.PLAYER_1:
			return ROTATION_PLAYER_1;
		OwningPlayer.PLAYER_2:
			return ROTATION_PLAYER_2;

static func complete_rotation(rotation_degrees : float):
	return 0 if rotation_degrees == ROTATION_PLAYER_1 else rotation_degrees;

static func get_direction(base_direction : int, owning_player : OwningPlayer):
	return base_direction if owning_player == OwningPlayer.PLAYER_1 else -base_direction;
