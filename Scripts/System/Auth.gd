const AUTH_FILE_NAME : String = "auth";

static func try_auth() -> bool:
	var json_data : Dictionary = System.Json.read(AUTH_FILE_NAME);
	if (System.Json.is_error(json_data)):
		return false;
	store_auth(AuthData.from_json(json_data));
	return true;

static func store_auth(authData : AuthData) -> void:
	System.authData = authData;
	System.Json.write(authData.get_json(), AUTH_FILE_NAME);
