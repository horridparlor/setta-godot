extends Node
class_name OperationRequest

const DOMAIN : String = "https://cardnot.com/";
const API_PATH : String = DOMAIN + "api/user/";
const ADMIN_PATH : String = API_PATH + "admin/";
const ASSETS_PATH : String = DOMAIN + "setta-assets/";

var operation : RequestEnums.Operation;
var endpoint : String;
var is_fetch : bool;
var file_path : String;

func _init(operation_ : RequestEnums.Operation, file_path_ : String = ""):
	operation = operation_;
	endpoint = RequestEnums.Endpoint[operation];
	is_fetch = RequestEnums.OperationRequestType[operation] == RequestEnums.RequestType.FETCH;
	file_path = file_path_;

func getEndpoint() -> String:
	return (ASSETS_PATH if is_fetch else API_PATH) + endpoint + file_path;
