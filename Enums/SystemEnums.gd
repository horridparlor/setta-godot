extends Node

const TEXT_COLOR_BLACK : Color = Color(0, 0, 0);
const TEXT_COLOR_PEARL_WHITE : Color = Color(243, 243, 243);
const TEXT_COLOR_WHITE : Color = Color(255, 255, 255);

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

enum EffectsFontSize {
	TINY,
	SMALL,
	CONCISE,
	REGULAR,
	DEFAULT
}

enum NameFontSize {
	SMALL,
	CONCISE,
	REGULAR,
	DEFAULT
}

static var CardFontSize = {
	EffectsFontSize.TINY: 15,
	EffectsFontSize.SMALL: 17,
	EffectsFontSize.CONCISE: 19,
	EffectsFontSize.REGULAR: 20,
	EffectsFontSize.DEFAULT: 23
}

static var LabelFontSize = {
	NameFontSize.SMALL: 25,
	NameFontSize.CONCISE: 28,
	NameFontSize.REGULAR: 31,
	NameFontSize.DEFAULT: 34
}

static func get_effects_font_size(size : EffectsFontSize) -> int:
	return CardFontSize[size];

static func get_name_font_size(size : NameFontSize) -> int:
	if size < 0:
		return get_effects_font_size(EffectsFontSize.DEFAULT);
	return LabelFontSize[size];

enum MontserratFont {
	ITALIC,
	REGULAR,
	SEMI_BOLD,
	BOLD,
	BOLD_ITALIC,
	HEAVY
}

static var FontPath = {
	MontserratFont.ITALIC: "res://Assets/FontFiles/Montserrat/Montserrat-LightItalic.ttf",	
	MontserratFont.REGULAR: "res://Assets/FontFiles/Montserrat/Montserrat-Regular.ttf",	
	MontserratFont.SEMI_BOLD: "res://Assets/FontFiles/Montserrat/Montserrat-SemiBold.ttf",	
	MontserratFont.BOLD: "res://Assets/FontFiles/Montserrat/Montserrat-Bold.ttf",	
	MontserratFont.BOLD_ITALIC: "res://Assets/FontFiles/Montserrat/Montserrat-BoldItalic.ttf",	
	MontserratFont.HEAVY: "res://Assets/FontFiles/Montserrat/Montserrat-ExtraBold.ttf"
}

static func get_font_path(font : MontserratFont) -> String:
	return FontPath[font];

static func get_italic_font() -> String:
	return get_font_path(MontserratFont.ITALIC);

static func get_regular_font() -> String:
	return get_font_path(MontserratFont.REGULAR);
	
static func get_semi_bold_font() -> String:
	return get_font_path(MontserratFont.SEMI_BOLD);
	
static func get_bold_font() -> String:
	return get_font_path(MontserratFont.BOLD);
	
static func get_bold_italic_font() -> String:
	return get_font_path(MontserratFont.BOLD_ITALIC);

static func get_heavy_font() -> String:
	return get_font_path(MontserratFont.HEAVY);

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

enum SaveFile {
	CARDS
}

static var SaveFilePath = {
	SaveFile.CARDS: "cards"
}

enum DataFileType {
	SAVE
}

static var DataFileExtension = {
	DataFileType.SAVE: 'save'
}

static func get_data_file_extension(type: DataFileType) -> String:
	return '.' + DataFileExtension[type];

static func get_json_extension() -> String:
	return get_data_file_extension(DataFileType.SAVE);

enum IconSize {
	SMALL,
	NORMAL
}

static var IconPixelSize = {
	IconSize.SMALL: 90,
	IconSize.NORMAL: 120
}

static func build_icon_path(size : IconSize, folder_path : String) -> String:
	return folder_path + str(IconPixelSize[size]) + get_image_extension();
