static func item(array : Array, random : RandomNumberGenerator) -> Variant:
	return array[random.randi()%array.size()];

static func instance_id(random : RandomNumberGenerator) -> int:
	return random.randi();
