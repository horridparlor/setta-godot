extends Node
class_name EffectTarget

var target_type : EffectEnums.TargetType;
var amount : int;

func _init(
	target_type_ : EffectEnums.TargetType,
	amount_ : int = 1
):
	target_type = target_type_;
	amount = amount_;
