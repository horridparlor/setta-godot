const EMPTY_DIGIT : String = "0";

static func to_standard_string(amount : int, size : int) -> String:
	var string : String = str(amount);
	return EMPTY_DIGIT.repeat(max(size - string.length(), 0)) + string;
	
