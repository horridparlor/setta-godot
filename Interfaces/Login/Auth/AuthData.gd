extends Node
class_name AuthData


var username : String;
var password : String;
var authToken : String;
var userId : int;
var firstname : String;
var lastname : String;
var accessRights : Dictionary;

func _init(
	username_ : String,
	password_ : String,
	authToken_ : String,
	userId_ : int,
	firstname_ : String,
	lastname_ : String,
	accessRights_ : Dictionary
):
	username = username_;
	password = password_;
	authToken = authToken_;
	userId = userId_;
	firstname = firstname_;
	lastname = lastname_;
	accessRights = accessRights_;

func get_json() -> Dictionary:
	return {
		'username': username,
		'password': password,
		'authToken': authToken,
		'userId': userId,
		'firstname': firstname,
		'lastname': lastname,
		'accessRights': accessRights
	}

static func from_json(json_data : Dictionary) -> AuthData:
	return AuthData.new(
		json_data.username,
		json_data.password,
		json_data.authToken,
		json_data.userId,
		json_data.firstname,
		json_data.lastname,
		json_data.accessRights
	)
