extends LoadingIcon

@onready var sprite : Sprite2D = $Sprite;

func _physics_process(delta : float) -> void:
	sprite.rotation_degrees += SPRITE_ROTATION_SPEED / sqrt(SystemEnums.IconPixelSize[size]) * delta;

func init(new_size : SystemEnums.IconSize = SystemEnums.IconSize.NORMAL) -> void:
	size = new_size;
	sprite.texture = load(get_texture_path());
