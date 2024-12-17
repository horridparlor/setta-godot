extends Node2D
class_name LoadingIcon

const ICON_FOLDER_PATH : String = "res://Assets/Icons/Common/loading/";
const SPRITE_ROTATION_SPEED : float = 300;

var size : SystemEnums.IconSize;

func init(new_size : SystemEnums.IconSize = SystemEnums.IconSize.NORMAL) -> void:
	pass;
	
func get_texture_path() -> String:
	return SystemEnums.build_icon_path(size, ICON_FOLDER_PATH);
