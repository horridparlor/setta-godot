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

static func from_list(source : Array) -> CardMaterials:
	var count : int = len(source);
	var primary = source[0] if count > 0 else null;
	var secondary = source[1] if count > 1 else null;
	var tertiary = source[2] if count > 2 else null;
	return CardMaterials.new(primary, secondary, tertiary);
