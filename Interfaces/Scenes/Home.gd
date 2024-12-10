extends Node2D
class_name Home

const SCENE_FOLDER_PATH : String = "res://Prefabs/Scenes/";
const GAMEPLAY_PATH : String = SCENE_FOLDER_PATH + "Gameplay.tscn";
const LOGIN_PATH : String = SCENE_FOLDER_PATH + "Login.tscn";
const NEXUS_PATH : String = SCENE_FOLDER_PATH + "Nexus.tscn";
const DEBUG_MODE_CODE : Array = [KEY_KP_8, KEY_KP_8, KEY_KP_2, KEY_KP_2, KEY_KP_4, KEY_KP_6, KEY_KP_4, KEY_KP_6, KEY_KP_1, KEY_KP_3];

var id_regex : RegEx = RegEx.new();
var gameplay : Gameplay;
var login : Login;
var nexus : Nexus;
var current_code_index : int = 0;

var cheat_deal_regex : RegEx = RegEx.new();
var cheat_draw_regex : RegEx = RegEx.new();
var cheat_discard_regex : RegEx = RegEx.new();
var cheat_gain_regex : RegEx = RegEx.new();
var cheat_mill_regex : RegEx = RegEx.new();
var cheat_randomize_regex : RegEx = RegEx.new();
