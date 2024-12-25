extends Node

enum RequestType {
	POST,
	GET,
	PUT,
	DELETE,
	FETCH
}

enum Operation {
	AUTHENTICATE,
	DELETE_DECKLIST,
	FIND_MATCH,
	GET_CARDS,
	GET_DECKLISTS,
	FETCH_ARTWORK,
	NONE,
	POST_DECKLIST,
	PUT_DECKLIST
}

static var OperationRequestType = {
	Operation.AUTHENTICATE: RequestType.POST,
	Operation.DELETE_DECKLIST: RequestType.DELETE,
	Operation.FIND_MATCH: RequestType.POST,
	Operation.GET_CARDS: RequestType.GET,
	Operation.GET_DECKLISTS: RequestType.GET,
	Operation.FETCH_ARTWORK: RequestType.FETCH,
	Operation.POST_DECKLIST: RequestType.POST,
	Operation.PUT_DECKLIST: RequestType.PUT
}

static func getMethod(operation: Operation) -> HTTPClient.Method:
	match OperationRequestType[operation]:
		RequestType.POST:
			return HTTPClient.Method.METHOD_POST;
		RequestType.PUT:
			return HTTPClient.Method.METHOD_PUT;
		RequestType.DELETE:
			return HTTPClient.Method.METHOD_DELETE;
	return HTTPClient.Method.METHOD_GET;

const GAMEPLAY_ENDPOINT_FOLDER = 'gameplay/';

const AUTHENTICATE_ENDPOINT = 'authenticate';
const DECKLIST_ENDPOINT = 'decklist';
const DECKLISTS_ENDPOINT = 'decklists';
const FIND_MATCH_ENDPOINT = GAMEPLAY_ENDPOINT_FOLDER + 'find-match';

static var Endpoint = {
	Operation.AUTHENTICATE: AUTHENTICATE_ENDPOINT,
	Operation.DELETE_DECKLIST: DECKLIST_ENDPOINT,
	Operation.FIND_MATCH: FIND_MATCH_ENDPOINT,
	Operation.GET_CARDS: 'cards?isGame=1',
	Operation.GET_DECKLISTS: DECKLISTS_ENDPOINT,
	Operation.FETCH_ARTWORK: 'small-art/',
	Operation.POST_DECKLIST: DECKLIST_ENDPOINT,
	Operation.PUT_DECKLIST: DECKLIST_ENDPOINT
}

enum ImageFileType {
	PNG,
	WEBP
}

static var ImageExtension = {
	ImageFileType.PNG: 'png',
	ImageFileType.WEBP: 'webp'
}

static func get_image_extension(type: ImageFileType) -> String:
	return '.' + ImageExtension[type];

static func get_png_extension() -> String:
	return get_image_extension(ImageFileType.PNG);

static func get_webp_extension() -> String:
	return get_image_extension(ImageFileType.WEBP);
