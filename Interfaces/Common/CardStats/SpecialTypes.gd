extends Node
class_name SpecialTypes

var is_ace : bool;
var is_pendulum : bool;
var is_maximum : bool;
var maximum_monster : CardEnums.MaximumMonster;
var maximum_piece : CardEnums.MaximumPiece;

func _init(
	is_ace_ : bool = false,
	is_pendulum_ : bool = false,
	is_maximum_ : bool = false,
	maximum_monster_ : CardEnums.MaximumMonster = CardEnums.MaximumMonster.NONE,
	maximum_piece_ : CardEnums.MaximumPiece = CardEnums.MaximumPiece.NONE
):
	is_ace = is_ace_;
	is_pendulum = is_pendulum_;
	is_maximum = is_maximum_;
	maximum_monster = maximum_monster_;
	maximum_piece = maximum_piece_;
