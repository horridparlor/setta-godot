extends GlowNode
class_name GameplayCard

signal pressed(_self);
signal released(_self);
signal update_playstate(_self);

const ARTWORK_LOAD_PREFIX : String = "res://Assets/CardArt/";
const ARTWORK_LOAD_SUBFIX : String = ".png";

const MOVEMENT_SPEED : int = 10;
const MAX_FOCUSED_SPEED : int = 3200;
const MAX_UNFOCUSED_SPEED : int = 1800;
const ROTATION_SCALE : float = 0.2;
const PLAYLINE : int = 42;
const SIZE : Vector2 = Vector2(428, 592);

const MAX_SCALE_VALUE : float = 1.0;
const MAX_SCALE : Vector2 = Vector2(MAX_SCALE_VALUE, MAX_SCALE_VALUE);
const BASE_SCALE : float = 0.5;
const BASE_SCALE_HAND : Vector2 = Vector2(BASE_SCALE, BASE_SCALE);
const FIELD_SCALE : float = 0.55;
const BASE_SCALE_FIELD : Vector2 = Vector2(FIELD_SCALE, FIELD_SCALE);
const ZOOM_IN_SPEED : int = 7;
const ZOOM_OUT_SPEED : int = 12;
const FINGER_SIZE : float = 2.6;
const CANCEL_PLAY_MULTIPLIER : float = 2.05;
const SKY_HEIGHT : int = 220;

const SPAWN_POINT : Vector2 = Vector2(0, 960);
const SPAWN_POINT_X : int = 960;
const SPAWN_POINT_Y_MULTIPLIER : float = 1.4;
const DESPAWN_POINT : Vector2 = Vector2(540, 960);
const DESPAWN_ORIGO_RANGE : int = 10;
const DESPAWN_WIND_RESISTANCE : int = 360;
const RETURN_TO_HAND_MARGIN : int = -10;

var is_focused : bool = false;
var is_moving : bool = false;
var origin_point : Vector2;
var scale_up : bool = false;
var scale_down : bool = false;
var zone : Zone;
var card_data : CardData;
var is_despawned : bool = false;
var debug : bool = false;
var base_rotation : int = 0;
