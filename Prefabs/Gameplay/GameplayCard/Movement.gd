static func set_origin(origin_point : Vector2, card : GameplayCard):
	card.origin_point = origin_point;
	card.is_moving = true;

static func focused(card : GameplayCard):
	card.is_focused = true;
	card.is_moving = true;
	card.scale_up = true;
	System.Children.focus(card, card.zone);
		
static func unfocused(card : GameplayCard):
	card.is_focused = false;
	card.scale_down = true;
	
static func movement_frame(delta : float, card : GameplayCard):
	if !card.is_moving:
		return;
	move_towards_mouse(delta, card);
	rotate(card, card.position, false, delta);
	stop_moving(card);
	zoom(card, delta);
	
static func stop_moving(card : GameplayCard):
	if !card.is_focused && System.Vectors.equal(card.position, card.origin_point)\
	and System.Scale.equal(card.rotation_degrees, card.base_rotation):
		card.is_moving = false;
		if card.is_despawned:
			card.queue_free();

static func move_towards_mouse(delta : float, card : GameplayCard):
	var current_position = card.position;
	var target_position = get_mouse_position(card)\
	if card.is_focused else card.origin_point;
	if target_position == null:
		return;
	var distance = current_position.distance_to(target_position);
	card.position = current_position.move_toward(target_position, \
		delta * min(card.MOVEMENT_SPEED * distance, \
		card.MAX_FOCUSED_SPEED if card.is_focused else card.MAX_UNFOCUSED_SPEED));
	rotate(card, current_position, true, delta);

static func get_mouse_position(card : GameplayCard):
	var position : Vector2 = card.zone.get_local_mouse_position();
	var card_edge : Vector2 = Vector2((System.Window_.x - card.scale.x * card.SIZE.x) / 2,\
	(System.Window_.y - card.scale.y * card.SIZE.y) / 2);
	position.y = make_room_for_finger(position.y, card);
	position.x = max(min(card_edge.x, position.x), -card_edge.x);
	position.y = max(min(card_edge.y, position.y), -card_edge.y);
	return position;

static func make_room_for_finger(y : float, card : GameplayCard):
	var card_data : CardData = card.card_data;
	var direction : int = -1 \
		if card_data.zone == CardEnums.Zone.FIELD \
		and card.base_rotation == GameplayEnums.ROTATION_PLAYER_2 else 1;
	return y - direction * card.SIZE.y * (card.MAX_SCALE\
	if card.is_focused and (card.card_data.zone != CardEnums.Zone.HAND)\
	else get_base_scale(card)).x / 2 * card.FINGER_SIZE;

static func rotate(card : GameplayCard, original_position : Vector2, do_rotate : bool, delta : float):
	if do_rotate || card.is_despawned:
		card.rotation_degrees += card.ROTATION_SCALE * (card.position.x - original_position.x);
	else:
		if !System.Scale.equal(card.rotation_degrees, card.base_rotation):
			card.rotation_degrees = System.Scale.baseline(card.rotation_degrees, card.base_rotation, delta);

static func zoom(card : GameplayCard, delta : float):
	if card.is_focused and card.scale_up:
		card.scale = card.scale.move_toward(card.MAX_SCALE, delta * card.ZOOM_IN_SPEED);
		if System.Vectors.equal(card.scale, card.MAX_SCALE):
			card.scale_up = false;
	elif card.scale_down:
		var base_scale : Vector2 = get_base_scale(card);
		card.scale = card.scale.move_toward(base_scale, delta * card.ZOOM_OUT_SPEED);
		if System.Vectors.equal(card.scale, base_scale):
			card.scale_down = false;

static func get_base_scale(card : GameplayCard):
	return card.BASE_SCALE_HAND \
		if CardEnums.Zone.HAND == CardEnums.Zone.HAND else card.BASE_SCALE_FIELD;
