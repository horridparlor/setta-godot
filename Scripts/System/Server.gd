static func parse_response(body : PackedByteArray):
	return JSON.parse_string(body.get_string_from_utf8());

static func request(operation : RequestEnums.Operation, parent : Node, file_path : String = ""):
	var http : HTTPRequest = OneTimeRequest.new();
	var request = OperationRequest.new(operation, file_path);
	var leave_raw = false;
	if (request.is_fetch):
		leave_raw = true;
	http.init(request, parent, leave_raw);

static func rapidcall(requests : Dictionary, parent : Node):
	for key in requests:
		request(requests[key], parent, key);

static func ids(parent : Node2D, own : bool = true):
	var player_id : int = parent.player_id;
	if !own:
		player_id = parent.enemy_id;
	return ".php?game_id=%d&player_id=%d" % [parent.game_id, player_id];
