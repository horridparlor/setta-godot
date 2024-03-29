extends Node
class_name EffectCost

var cost_type : EffectEnums.CostType;
var target : EffectTarget;
var amount : int;

func _init(
	cost_type_ : EffectEnums.CostType,
	target_ : EffectTarget,
	amount_ : int
):
	cost_type = cost_type_;
	target = target_;
	amount = amount_;
