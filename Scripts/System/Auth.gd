const AUTH_FILE_NAME : String = "auth";

static func try_auth(parent : Node) -> bool:
	var auth_data : AuthData;
	var json_data : Dictionary = System.Json.read(AUTH_FILE_NAME);
	if (System.Json.is_error(json_data)):
		return false;
	auth_data = AuthData.from_json(json_data);
	System.auth_data = auth_data;
	auth_data.authenticate(parent);
	return true;

static func store_auth(auth_data : AuthData) -> void:
	System.auth_data = auth_data;
	System.Json.write(auth_data.get_json(), AUTH_FILE_NAME);
	System.Server.store_server_configuration({
		"server_ip": System.server_ip
	});

static func eat(json_data : Dictionary) -> void:
	var auth_data : AuthData = AuthData.new(
		System.auth_data.username,
		System.auth_data.password,
		json_data.authToken,
		json_data.userId,
		json_data.firstname,
		json_data.lastname,
		json_data.accessRights
	);
	store_auth(auth_data);
