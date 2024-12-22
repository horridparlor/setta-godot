extends GlowNode
class_name EnumSelector

var options : Dictionary;
var chosen_option : EnumOption;

func init(label_message : String, new_options : Dictionary, default = null, preselected = null) -> void:
	pass;

func get_chosen() -> EnumOption:
	return chosen_option;

func clear() -> void:
	pass;
