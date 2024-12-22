static func read_boolean(option : SystemEnums.BooleanOption) -> bool:
	return option == SystemEnums.BooleanOption.TRUE;

static func build_options(values : Array, names : Dictionary, default : int) -> Dictionary:
	var options : Dictionary;
	var index : int = 1;
	for option in values:
		if option == default:
			continue;
		options[index] = EnumOption.new(names[option], option);
		index += 1;
	return options;

static func build_boolean_options(message : String,
default : SystemEnums.BooleanOption = SystemEnums.BooleanOption.NONE) -> Dictionary:
	var names : Dictionary = {
		SystemEnums.BooleanOption.TRUE: "Is %s" % message,
		SystemEnums.BooleanOption.FALSE: "Not %s" % message
	}
	return build_options(SystemEnums.BooleanOption.values(), names, default);
