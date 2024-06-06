extends Node
class_name OperationRequest

const DOMAIN : String = "https://setta.fi/";
const PATH : String = DOMAIN + "setta-back/api/user/";

var operation : RequestEnums.Operation;
var endpoint : String;

func _init(operation_ : RequestEnums.Operation):
	operation = operation_;
	endpoint = RequestEnums.Endpoint[operation];

func getEndpoint() -> String:
	return PATH + endpoint;
