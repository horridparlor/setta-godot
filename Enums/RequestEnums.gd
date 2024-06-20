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
	WEBP
}

static var ImageExtension = {
	ImageFileType.WEBP: 'webp'
}

static func getImageExtension(type: ImageFileType) -> String:
	return ImageExtension[type];

static func getWebpExtension() -> String:
	return getImageExtension(ImageFileType.WEBP);
