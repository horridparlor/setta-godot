extends Node
class_name OperationRequest

var operation : RequestEnums.Operation;
var method : HTTPClient.Method;
var endpoint : String;
var is_fetch : bool;
var file_path : String;
var params : Dictionary;
var local_data : Dictionary;

func _init(operation_ : RequestEnums.Operation, params_ : Dictionary, file_path_ : String = "", local_data_ : Dictionary = {}):
	operation = operation_;
	endpoint = RequestEnums.Endpoint[operation];
	method = RequestEnums.getMethod(operation);
	is_fetch = RequestEnums.OperationRequestType[operation] == RequestEnums.RequestType.FETCH;
	file_path = file_path_;
	params = params_;
	local_data = local_data_;

func get_endpoint() -> String:
	return System.Server.REQUEST_PREFIX + System.server_ip + \
	(System.Server.ASSETS_PATH if is_fetch else System.Server.API_PATH) + \
	endpoint + file_path;

func get_params() -> PackedStringArray:
	var packed = []
	for key in params.keys():
		var pair = str(key) + "=" + str(params[key]);
		packed.append(pair);
	return packed;

func debug() -> void:
	print(get_endpoint());
	print(params);
