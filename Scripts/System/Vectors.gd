const INDIFFERENT_DISTANCE : float = 0.01;

static func is_default(vector : Vector2) -> bool:
	return is_same(vector, default());

static func default() -> Vector2:
	return Vector2(0, 0);

static func equal(vector_a : Vector2, vector_b : Vector2, extra_distance : float = 0) -> bool:
	return vector_a.distance_to(vector_b) <= INDIFFERENT_DISTANCE + extra_distance;

static func synchronize(target : Vector2, current : Vector2) -> Vector2:
	var direction : Vector2 = Vector2(System.Floats.direction(current.x), System.Floats.direction(current.y));
	target = Vector2(direction.x * abs(target.x), direction.y * abs(target.y));
	return target;
