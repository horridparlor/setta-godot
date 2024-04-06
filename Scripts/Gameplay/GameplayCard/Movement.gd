static func set_origin(origin_point : Vector2, card : GameplayCard) -> void:
	card.origin_point = origin_point;
	card.is_moving = true;
	set_visual_effects(card);

static func set_visual_effects(card : GameplayCard) -> void:
	set_rotation(card);
	set_modal_position(card);
	card.Sleeves.set_face(card);

static func set_modal_position(card : GameplayCard) -> void:
	card.modal_layer.position.x = card.MODAL_X_UPRIGHT \
		if card.base_rotation == card.ROTATION_ATTACK \
		or card.card_data.zone == CardEnums.Zone.HAND else card.MODAL_X_SIDEWAYS;

static func move_left(amount : float, card : GameplayCard) -> void:
	card.origin_point.x -= amount;

static func set_rotation(card : GameplayCard) -> void:
	card.base_rotation = card.ROTATION_DEFENSE \
	if !card.do_interact() and is_sideways(card) \
	else get_up_rotation(card);

static func get_up_rotation(card : GameplayCard) -> float:
	return card.zone.get_card_rotation(card.origin_point.x) \
		if !card.do_interact() and card.zone else card.ROTATION_ATTACK;

static func is_sideways(card : GameplayCard) -> bool:
	var monster_data : MonsterData = card.card_data.monster_data;
	return monster_data and monster_data.monster_position == CardEnums.MonsterPosition.DEFENSE;

static func focus(card : GameplayCard):
	card.focus_state = GameplayEnums.FocusState.WAITING;

static func examine(card : GameplayCard, gameplay : Gameplay):
	card.focus_state = GameplayEnums.FocusState.EXAMINE;
	card.Modals.examine(card, gameplay);
	
static func interact(card : GameplayCard, gameplay : Gameplay):
	card.Modals.interact(card, gameplay);
	card.focus_state = GameplayEnums.FocusState.INTERACT;
	card.is_moving = true;
	card.scale_up = true;
	set_visual_effects(card);
	System.Children.focus(card, card.zone);
	card.Core.control_glow(GameplayEnums.GlowState.GLOW, card, gameplay);
		
static func unfocus(card : GameplayCard, gameplay : Gameplay):
	card.focus_state = GameplayEnums.FocusState.NONE;
	card.Modals.close_modal(card, gameplay);
	card.scale_down = true;
	set_visual_effects(card);
	
static func movement_frame(delta : float, card : GameplayCard):
	if !card.is_moving:
		return;
	move_towards_mouse(delta, card);
	rotate(card, card.position, false, delta);
	stop_moving(card);
	zoom(card, delta);
	
static func stop_moving(card : GameplayCard):
	if !card.do_interact() && System.Vectors.equal(card.position, card.origin_point)\
	and (System.Scale.equal(card.rotation_degrees, card.base_rotation) or card.is_despawned):
		movement_ready(card);

static func movement_ready(card : GameplayCard):
	card.is_moving = false;
	if card.is_despawned:
		card.queue_free();

static func move_towards_mouse(delta : float, card : GameplayCard):
	var current_position = card.position;
	var target_position = get_mouse_position(card)\
	if card.do_interact() else card.origin_point;
	if target_position == null:
		return;
	var distance = current_position.distance_to(target_position);
	card.position = current_position.move_toward(target_position, \
		delta * min(card.MOVEMENT_SPEED * distance, \
		card.MAX_FOCUSED_SPEED if card.do_interact() else card.MAX_UNFOCUSED_SPEED));
	rotate(card, current_position, true, delta);

static func get_mouse_position(card : GameplayCard):
	var position : Vector2 = card.zone.get_local_mouse_position();
	var local_public_difference : Vector2 = position - card.zone.get_global_mouse_position();
	var card_edge : Vector2 = Vector2((System.Window_.x - card.scale.x * card.SIZE.x) / 2,\
	(System.Window_.y - card.scale.y * card.SIZE.y) / 2);
	position.y = make_room_for_finger(position.y, card);
	position.x = max(min(card_edge.x, position.x), -card_edge.x);
	position.y = max(min(card_edge.y, position.y), local_public_difference.y -card_edge.y);
	return position;

static func make_room_for_finger(y : float, card : GameplayCard):
	var card_data : CardData = card.card_data;
	var direction : int = 1 \
		if card_data.owning_player == GameplayEnums.OwningPlayer.YOU else -1;
	return y - direction * card.SIZE.y * get_base_scale(card).x / 2 * card.FINGER_SIZE;

static func rotate(card : GameplayCard, original_position : Vector2, do_rotate : bool, delta : float):
	if do_rotate || card.is_despawned:
		card.rotation_degrees += card.ROTATION_SCALE * (card.position.x - original_position.x);
	else:
		if !System.Scale.equal(card.rotation_degrees, card.base_rotation):
			card.rotation_degrees = System.Scale.baseline(card.rotation_degrees, card.base_rotation, delta);
	card.modal_rotation = -card.rotation_degrees;
	card.modal_layer.rotation_degrees = 0 if card.card_data.zone == CardEnums.Zone.HAND \
		else card.modal_rotation;

static func zoom(card : GameplayCard, delta : float):
	if card.do_interact():
		card.scale = card.scale.move_toward(card.MAX_SCALE, delta * card.ZOOM_IN_SPEED);
		if System.Vectors.equal(card.scale, card.MAX_SCALE):
			card.scale_up = false;
	elif card.scale_down:
		var base_scale : Vector2 = get_base_scale(card);
		card.scale = card.scale.move_toward(base_scale, delta * card.ZOOM_OUT_SPEED);
		if System.Vectors.equal(card.scale, base_scale):
			card.scale_down = false;

static func get_base_scale(card : GameplayCard):
	match card.zone.zone:
		CardEnums.Zone.FIELD:
			return card.BASE_SCALE_FIELD;
		CardEnums.Zone.HAND:
			return card.BASE_SCALE_HAND;
		CardEnums.Zone.MODAL:
			return card.BASE_SCALE_MODAL;
	return card.BASE_SCALE_HAND;
