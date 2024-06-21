const IMAGE_WRITE_PATH_PREFIX : String = "user://small-art/";

static func create_directory() -> void:
	var dir: DirAccess = DirAccess.open(IMAGE_WRITE_PATH_PREFIX);
	if dir == null:
		DirAccess.make_dir_recursive_absolute(IMAGE_WRITE_PATH_PREFIX);

static func load_from_buffer(buffer: PackedByteArray) -> Image:
	var img : Image = Image.new();
	var error = img.load_webp_from_buffer(buffer);
	if error != OK:
		error = img.load_png_from_buffer(buffer);
		if error != OK:
			error = img.load_jpg_from_buffer(buffer);
	img.resize(372, 320);
	return img;

static func write(image: Image, file_name: String):
	var file : FileAccess = FileAccess.open(get_file_path(file_name), FileAccess.ModeFlags.WRITE);
	if file:
		var buffer : PackedByteArray = image.save_png_to_buffer();
		file.store_buffer(buffer);
		file.close();

static func read(file_name: String) -> Image:
	var file : FileAccess = FileAccess.open(get_file_path(file_name), FileAccess.ModeFlags.READ);
	if file:
		var buffer : PackedByteArray = file.get_buffer(file.get_length());
		file.close();
		return load_from_buffer(buffer);
	return null;

static func get_file_path(file_name : String) -> String:
	return IMAGE_WRITE_PATH_PREFIX + file_name + RequestEnums.get_png_extension();

static func is_valid(image : Image) -> bool:
	return image.get_size() != Vector2i();
