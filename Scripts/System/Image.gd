static func load_from_buffer(buffer: PackedByteArray) -> Image:
	var img : Image = Image.new();
	var error = img.load_webp_from_buffer(buffer);
	if error != OK:
		error = img.load_png_from_buffer(buffer);
		if error != OK:
			error = img.load_jpg_from_buffer(buffer);
	img.resize(372, 320);
	return img;
