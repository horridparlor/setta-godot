const AUTH_STORE_PATH : String = "user_auth";

static func getUser():
	return System.Json.read(AUTH_STORE_PATH);

static func storeUser(user_auth):
	System.Json.write(user_auth, AUTH_STORE_PATH);
