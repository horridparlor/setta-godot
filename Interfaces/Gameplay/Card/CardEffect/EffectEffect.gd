extends Node
class_name EffectEffect

var effect_type : EffectEnums.EffectType;
var target : EffectTarget;
var amount : int;

func _init(
	effect_type_ : EffectEnums.EffectType,
	target_ : EffectTarget,
	amount_ : int
):
	effect_type = effect_type_;
	target = target_;
	amount = amount_;
