extends Node

enum FileExtension {
	IMAGE,
	NODE,
	SCRIPT
}

static var FileExtensionPath = {
	FileExtension.IMAGE: ".png",
	FileExtension.NODE: ".tscn",
	FileExtension.SCRIPT: ".gd",
}

enum Fonts {
	HEAVY
}

static var FontPath = {
	Fonts.HEAVY: "res://Assets/FontFiles/Montserrat/Montserrat-ExtraBold.ttf"	
}

static func get_font_paths(fonts : Array) -> Array:
	var paths : Array;
	for font in fonts:
		paths.append(FontPath[font]);
	return paths;

static func extra_deck_text(plain_text : String) -> String:
	return plain_text % get_font_paths([Fonts.HEAVY]);

static func get_extension_path(extension : FileExtension) -> String:
	return FileExtensionPath[extension];

static func get_image_extension() -> String:
	return get_extension_path(SystemEnums.FileExtension.IMAGE);

static func get_node_extension() -> String:
	return get_extension_path(SystemEnums.FileExtension.NODE);
	
static func get_script_extension() -> String:
	return get_extension_path(SystemEnums.FileExtension.SCRIPT);

enum CommonNodes {
	GameplayCard
}

static var CommonNodePath = {
	CommonNodes.GameplayCard: "res://Prefabs/Gameplay/GameplayCard.tscn"
}

static func get_card_path() -> String:
	return CommonNodePath[CommonNodes.GameplayCard];

enum DebugMode {
	CARD_DEBUG,
	NONE,
}
