extends Node2D
class_name GameplayCard

signal pressed(_self);
signal released(_self);
signal update_playstate(_self);
signal card_action(action, _self);

const DEBUG_FORMAT : String = "%s: %s";
const ARTWORK_LOAD_PREFIX : String = "res://Assets/CardArt/";
const ATTRIBUTE_SPRITE_PREFIX : String = "res://Assets/Icons/Attributes/";

const SUMMON_MODAL_PATH : String = "res://Prefabs/Gameplay/CardModals/SummonModal.tscn";
const TRIBUTE_MODAL_PATH : String = "res://Prefabs/Gameplay/CardModals/TributeModal.tscn";
const MODAL_MIN_HEIGHT : int = 290;
const MODAL_OPTION_HEIGHT : int = 140;
const SLEEVE_LOAD_PREFIX : String = "res://Prefabs/Gameplay/CardSleeves/";
const MIDDLE_FRAME_PATH : String = "res://Prefabs/Gameplay/CardFragment/MiddleFrame/";
const LEVEL_FRAME_PATH : String = "res://Assets/Icons/LevelFrame.png";
const DECK_MASTER_LEVEL_FRAME_PATH : String = "res://Assets/Icons/DeckMasterLevelFrame.png";
const DECK_MASTER_ATTRIBUTE_SPRITE_PREFIX : String = "res://Assets/Icons/Attributes/DeckMasterSize/";

const MOVEMENT_SPEED : int = 10;
const MAX_FOCUSED_SPEED : int = 3200;
const MAX_UNFOCUSED_SPEED : int = 1800;
const ROTATION_SCALE : float = 0.2;
const PLAYLINE : int = 42;
const SIZE : Vector2 = Vector2(428, 592);
const ROTATION_ATTACK : int = 0;
const ROTATION_DEFENSE : int = 90;
const MODAL_X_UPRIGHT : int = 0;
const MODAL_X_SIDEWAYS : int = FIELD_SCALE * (SIZE.y - SIZE.x);

const MAX_SCALE_VALUE : float = 1.0;
const MAX_SCALE : Vector2 = Vector2(MAX_SCALE_VALUE, MAX_SCALE_VALUE);
const BASE_SCALE : float = 0.5;
const BASE_SCALE_HAND : Vector2 = Vector2(BASE_SCALE, BASE_SCALE);
const FIELD_SCALE : float = 0.48;
const BASE_SCALE_FIELD : Vector2 = Vector2(FIELD_SCALE, FIELD_SCALE);
const SHOWCASE_SCALE : float = 0.39;
const BASE_SCALE_SHOWCASE : Vector2 = Vector2(SHOWCASE_SCALE, SHOWCASE_SCALE);
const MODAL_SCALE : float = 0.56;
const BASE_SCALE_MODAL : Vector2 = Vector2(MODAL_SCALE, MODAL_SCALE);

const ZOOM_IN_SPEED : int = 7;
const ZOOM_OUT_SPEED : int = 12;
const FINGER_SIZE : float = 2.8;
const CANCEL_PLAY_MULTIPLIER : float = 2.05;
const SKY_HEIGHT : int = 220;

const SPAWN_POINT : Vector2 = Vector2(0, 960);
const SPAWN_POINT_X : int = 960;
const SPAWN_POINT_Y_MULTIPLIER : float = 1.4;
const DESPAWN_POINT : Vector2 = Vector2(540, 960);
const DESPAWN_ORIGO_RANGE : int = 10;
const DESPAWN_WIND_RESISTANCE : int = 360;

var is_moving : bool = false;
var origin_point : Vector2;
var scale_up : bool = false;
var scale_down : bool = false;
var is_despawned : bool = false;
var base_rotation : int = 0;

var zone : Zone;
var card_data : CardData;
var focus_state : GameplayEnums.FocusState = GameplayEnums.FocusState.NONE;
var glow_state : GameplayEnums.GlowState = GameplayEnums.GlowState.GLOW;
var modal : Control;
var card_sleeve : CardSleeve;
var modal_rotation : float;

func do_interact() -> bool:
	return focus_state == GameplayEnums.FocusState.INTERACT;

func is_showcase() -> bool:
	return card_data.zone == CardEnums.Zone.SHOWCASE;

func debug(code : int, message : String = "") -> void:
	if !do_debug():
		return;
	print(DEBUG_FORMAT % [code, message]);

func do_debug() -> bool:
	return card_data.instance_id == System.debug_id;
