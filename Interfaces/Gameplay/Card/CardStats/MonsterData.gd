extends Node
class_name MonsterData

var level : int;
var atk : int;
var def : int;
var position : CardEnums.MonsterPosition = CardEnums.MonsterPosition.ATTACK;

var monster_position : CardEnums.MonsterPosition;
var atk_gain : int;
var def_gain : int;
var atk_long_gain : int;
var def_long_gain : int;
var keywords : Array;
var long_keywords : Array;

func _init(
	level_ : int = 0,
	atk_ : int = 0,
	def_ : int = 0
):
	level = level_;
	atk = atk_;
	def = def_;

func to_attack_position() -> void:
	monster_position = CardEnums.MonsterPosition.ATTACK;

func to_defense_position() -> void:
	monster_position = CardEnums.MonsterPosition.DEFENSE;
