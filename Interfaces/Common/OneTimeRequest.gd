extends HTTPRequest
class_name OneTimeRequest

const TIMEOUT_TIME : float = 5;

var operation : RequestEnums.Operation;
var parent : Node;
var leave_raw : bool;
var original_request : OperationRequest;

func init(op_request : OperationRequest, new_parent : Node, _leave_raw : bool) -> void:
	original_request = op_request;
	leave_raw = _leave_raw;
	timeout = TIMEOUT_TIME;
	if System.Debug.REQUESTS and (System.Debug.REQUESTS_FILTER == op_request.operation):
		op_request.debug();
	add_parent(new_parent)
	operation = op_request.operation;
	self.request_completed.connect(self.complete_request);
	request(op_request.get_endpoint(), get_headers(), op_request.method, JSON.stringify(op_request.params));

func get_headers() -> PackedStringArray:
	return [
		"Authorization: Bearer " + System.auth_data.authToken
	] if System.auth_data else [];

func add_parent(new_parent : Node) -> void:
	parent = new_parent;
	parent.add_child(self);

func complete_request(result : int, response_code : int, headers : PackedStringArray, body : PackedByteArray) -> void:
	var response = {"body": body} if leave_raw else [body];
	if !leave_raw:
		response = System.Server.parse_response(body);
	response = parse_response(response);
	if System.Debug.RESPONSES and (System.Debug.REQUESTS_FILTER == original_request.operation):
		printt(result, response_code, headers, response);
	if response.is_empty():
		response = {
			"error": "Server could not be reached {%s}" % [System.server_ip]
		}
	if operation != RequestEnums.Operation.NONE:
		parent._on_http_response(original_request, operation, response);
	queue_free();

func parse_response(response) -> Dictionary:
	if response == null:
		return {};
	return response;

func _on_timeout() -> void:
	complete_request(0, 404, [], []);
