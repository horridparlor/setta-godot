extends HTTPRequest
class_name OneTimeRequest

var operation : RequestEnums.Operation;
var parent : Node;
var leave_raw : bool;
var original_request : OperationRequest;

func init(request : OperationRequest, new_parent : Node, _leave_raw : bool) -> void:
	original_request = request;
	leave_raw = _leave_raw;
	if System.Debug.REQUESTS and (System.Debug.REQUESTS_FILTER == request.operation):
		request.debug();
	add_parent(new_parent)
	operation = request.operation;
	self.request_completed.connect(self.complete_request);
	request(request.getEndpoint(), [], request.method, str(request.params));

func add_parent(new_parent : Node) -> void:
	parent = new_parent;
	parent.add_child(self);

func complete_request(result : int, response_code : int, headers : PackedStringArray, body : PackedByteArray) -> void:
	var response = {"body": body} if leave_raw else [body];
	if !leave_raw:
		response = System.Server.parse_response(body);
	response = parse_response(response);
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
