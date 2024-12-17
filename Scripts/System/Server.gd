const REQUEST_PREFIX : String = "http://";
const DEFAULT_SERVER_IP : String = "127.0.0.1";
const PORT : String = ":8000/";
const API_PATH : String = PORT + "api/user/";
const ASSETS_PATH : String = PORT + "setta-assets/";
const SERVER_CONFIGURATION_FILE_NAME : String = "server-configuration";

static func init() -> void:
	var json_data : Dictionary = System.Json.read(SERVER_CONFIGURATION_FILE_NAME);
	if (System.Json.is_error(json_data)):
		return;
	System.server_ip = json_data.server_ip;

static func store_server_configuration(json_data : Dictionary) -> void:
	System.Json.write(json_data, SERVER_CONFIGURATION_FILE_NAME);

static func parse_response(body : PackedByteArray):
	return JSON.parse_string(body.get_string_from_utf8());

static func request(operation : RequestEnums.Operation, params : Dictionary, parent : Node, file_path : String = "", local_data : Dictionary = {}):
	var http : HTTPRequest = OneTimeRequest.new();
	var request = OperationRequest.new(operation, params, file_path, local_data);
	var leave_raw = false;
	if (request.is_fetch):
		leave_raw = true;
	http.init(request, parent, leave_raw);

static func ids(parent : Node2D, own : bool = true):
	var player_id : int = parent.player_id;
	if !own:
		player_id = parent.enemy_id;
	return ".php?game_id=%d&player_id=%d" % [parent.game_id, player_id];
