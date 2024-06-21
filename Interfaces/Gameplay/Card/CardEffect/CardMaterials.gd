extends Node
class_name CardMaterials

var primary_material_id;
var secondary_material_id;
var tertiary_material_id;

func _init(
	primary_material_id_,
	secondary_material_id_,
	tertiary_material_id_
):
	primary_material_id = primary_material_id_;
	secondary_material_id = secondary_material_id_;
	tertiary_material_id = tertiary_material_id_;

func list() -> Array:
	return [
		primary_material_id,
		secondary_material_id,
		tertiary_material_id
	].filter(func(id):
		return id != null
	);
