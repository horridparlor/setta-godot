extends Node
class_name CardMaterials

var primary_material : CardEnums.Card;
var secondary_material : CardEnums.Card;
var tertiary_material : CardEnums.Card;

func _init(
	primary_material_ : CardEnums.Card,
	secondary_material_ : CardEnums.Card,
	tertiary_material_ : CardEnums.Card
):
	primary_material = primary_material_;
	secondary_material = secondary_material_;
	tertiary_material = tertiary_material_;
