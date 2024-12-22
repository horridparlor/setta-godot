extends GlowNode
class_name EnumSelector

var options : Dictionary;
var chosen_option : EnumOption;

func init(label_message : String, new_options : Dictionary, default = null, preselected = null) -> void:
	pass;

func get_chosen() -> EnumOption:
	return chosen_option;

func get_value():
	return get_chosen().value;

func clear() -> void:
	pass;
