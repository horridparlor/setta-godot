extends Node
class_name MonsterData

var level : int;
var atk : int;
var def : int;

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
