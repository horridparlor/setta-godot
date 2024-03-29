extends Node2D
class_name GlowNode

enum IsActive {
	GLOWING,
	NOT,
	SHUTTERING
}

const MAX_TOP_GLOW : float = 1.5;
const MIN_TOP_GLOW : float = 1.125;
const MAX_SPEED : float = 0.25;
const MIN_SPEED : float = 0.0625;

const BASE_INTENSITY : float = 1.0;
const RADIATE_SPEED_MULTIPLIER : int = 10
const SHUTTERED_INTENSITY : float = 0.72;
const SHUTTER_SPEED_MULTIPLIER : int = 9

var animations_active : IsActive = IsActive.NOT;
var glow_intensity : float = 1.0;
var glowing_direction : int = 1;
var glow_speed : float;
var top_glow : float;
var radiates : bool = false;

func _physics_process(delta : float) -> void:
	match animations_active:
		IsActive.GLOWING:
			glow_frame(delta);
		IsActive.SHUTTERING:
			shutter_frame(delta);

func glow_frame(delta : float) -> void:
	glow_intensity += glowing_direction * glow_speed * \
		(RADIATE_SPEED_MULTIPLIER if radiates else 1) * delta;
	if glowing_direction == 1 and glow_intensity >= top_glow or \
	glowing_direction == -1 and glow_intensity <= BASE_INTENSITY:
		if radiates:
			radiates = false;
		glowing_direction *= -1;
	modulate = Color(glow_intensity, glow_intensity, glow_intensity);

func shutter_frame(delta : float) -> void:
	glow_intensity -= glow_speed * SHUTTER_SPEED_MULTIPLIER * delta;
	if glow_intensity <= SHUTTERED_INTENSITY:
		glow_intensity = SHUTTERED_INTENSITY;
	modulate = Color(glow_intensity, glow_intensity, glow_intensity);

func activate_animations(random : RandomNumberGenerator) -> bool:
	if animations_active != IsActive.NOT:
		return false;
	top_glow = random.randf_range(MIN_TOP_GLOW, MAX_TOP_GLOW);
	glow_intensity = random.randf_range(1.0, top_glow);
	set_glow_speed(random);
	animations_active = IsActive.GLOWING
	return true;

func set_glow_speed(random : RandomNumberGenerator) -> void:
	glow_speed = random.randf_range(MIN_SPEED, MAX_SPEED);

func deactivate_animations() -> void:
	animations_active = IsActive.NOT;

func toggle_animations(boolean : bool, random : RandomNumberGenerator) -> void:
	if boolean:
		activate_animations(random);
	else:
		deactivate_animations();

func shutter(random : RandomNumberGenerator) -> void:
	if !activate_animations(random):
		set_glow_speed(random);
	animations_active = IsActive.SHUTTERING;

func glow(random : RandomNumberGenerator) -> void:
	activate_animations(random);
	if animations_active == IsActive.SHUTTERING:
		glowing_direction = 1;		
		radiates = true;
	animations_active = IsActive.GLOWING;
