extends Node

enum RequestType {
	POST,
	GET,
	PUT,
	DELETE
}

enum Operation {
	GET_CARDS,
	NONE
}

static var OperationRequestType = {
	Operation.GET_CARDS: RequestType.GET
}

static var Endpoint = {
	Operation.GET_CARDS: 'cards'
}
