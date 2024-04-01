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
