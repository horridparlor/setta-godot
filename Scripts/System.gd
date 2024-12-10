extends Node

const Auth : GDScript = preload("res://Scripts/System/Auth.gd");
const CardData : GDScript = preload("res://Scripts/System/CardData.gd");
const Children : GDScript = preload("res://Scripts/System/Children.gd");
const Debug : GDScript = preload("res://Scripts/System/Debug.gd");
const Decklist : GDScript = preload("res://Scripts/System/Decklist.gd");
const Floats : GDScript = preload("res://Scripts/System/Floats.gd");
const Image_ : GDScript = preload("res://Scripts/System/Image.gd");
const Ints : GDScript = preload("res://Scripts/System/Ints.gd");
const Instance : GDScript = preload("res://Scripts/System/Instance.gd");
const Json : GDScript = preload("res://Scripts/System/Json.gd");
const Random : GDScript = preload("res://Scripts/System/Random.gd");
const Scale : GDScript = preload("res://Scripts/System/Scale.gd");
const Server : GDScript = preload("res://Scripts/System/Server.gd");
const String_ : GDScript = preload("res://Scripts/System/String.gd");
const Vectors : GDScript = preload("res://Scripts/System/Vectors.gd");
const Window_ : Vector2 = Vector2(1920, 1080);

var debug_mode : SystemEnums.DebugMode = SystemEnums.DebugMode.NONE;
var debug_id : int;
var cards : Dictionary;
var main_deck_cards : Dictionary;
var extra_deck_cards : Dictionary;
var is_ready : bool = false;
var auth_data : AuthData;
var server_ip : String = Server.DEFAULT_SERVER_IP;

static func wait(delay : float, parent : Node2D) -> void:
	await parent.get_tree().create_timer(delay).timeout;

static func init() -> void:
	create_directories();

static func create_directories() -> void:
	Image_.create_directory();
	Json.create_directory();
