static func if_then_and_space(message : String) -> String:
	return message + " " if message.length() else "";

static func if_then_space_and(message : String) -> String:
	return " " + message if message.length() else "";

static func if_then_surrounded_by(message : String, prefix : String, subfix : String) -> String:
	return prefix + message + subfix if message.length() else "";
	
static func if_then_quoted(message : String, quote : String = "\"") -> String:
	return quote + message + quote if message.length() else "";

static func cap_first(message : String) -> String:
	if message.length():
		return message[0].to_upper() + message.substr(1, message.length());
	return message;

static func serialize(message : String) -> String:
	var words : Array;
	for word in message.split(" "):
		words.append(cap_first(word));
	return "".join(words);

static func contains(message : String, substring : String) -> bool:
	return substring.is_empty() || message.find(substring) != -1;

static func last(message : String) -> String:
	return message[len(message) - 1] if len(message) else "";
