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
	GET_CARDS,
	FETCH_ARTWORK,
	NONE
}

static var OperationRequestType = {
	Operation.AUTHENTICATE: RequestType.POST,
	Operation.GET_CARDS: RequestType.GET,
	Operation.FETCH_ARTWORK: RequestType.FETCH,
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

static var Endpoint = {
	Operation.AUTHENTICATE: 'authenticate',
	Operation.GET_CARDS: 'cards?isGame=1',
	Operation.FETCH_ARTWORK: 'small-art/',
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
