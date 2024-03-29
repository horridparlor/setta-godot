extends Node
class_name CardEffects

var cost : EffectCost;
var effect : EffectEffect;
var materials : CardMaterials;
var counts_as : CardEnums.Card;

func _init(
	cost_ : EffectCost,
	effect_ : EffectEffect,
	materials_ : CardMaterials = null,
	counts_as_ : CardEnums.Card = CardEnums.Card.NONE
):
	cost = cost_;
	effect = effect_;
	materials = materials_;
	counts_as = counts_as_;
