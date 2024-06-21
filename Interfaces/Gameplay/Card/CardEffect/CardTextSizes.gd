extends Node
class_name CardTextSizes

var name_size : int;
var materials_size : int;
var effects_size : int;

func _init(
	name_size_ : int,
	materials_size_ : int,
	effects_size_ : int
):
	name_size = name_size_;
	materials_size = materials_size_;
	effects_size = effects_size_;

func list() -> Array:
	return [
		name_size,
		materials_size,
		effects_size
	].filter(func(id):
		return id != null
	);

static func from_list(source : Array) -> CardTextSizes:
	return CardTextSizes.new(source[0], source[1], source[2]);
