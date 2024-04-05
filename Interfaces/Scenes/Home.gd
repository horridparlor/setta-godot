extends Node2D
class_name Home

const GAMEPLAY_PATH : String = "res://Prefabs/Scenes/Gameplay.tscn";

var id_regex : RegEx = RegEx.new();
var cheat_draw_regex : RegEx = RegEx.new();
var gameplay : Gameplay;
