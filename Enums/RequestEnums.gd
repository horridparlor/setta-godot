extends Node

enum RequestType {
	POST,
	GET,
	PUT,
	DELETE,
	FETCH
}

enum Operation {
	GET_CARDS,
	FETCH_ARTWORK,
	NONE
}

static var OperationRequestType = {
	Operation.GET_CARDS: RequestType.GET,
	Operation.FETCH_ARTWORK: RequestType.FETCH,
}

static var Endpoint = {
	Operation.GET_CARDS: 'cards',
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
