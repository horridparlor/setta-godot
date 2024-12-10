extends Node2D
class_name Login

signal authenticated();

const RAIL_POSITION_UP : int = -420;
const RAIL_POSITION_DOWN : int = 0;
const RAIL_SPEED_UP : int = 20;
const RAIL_SPEED_DOWN : int = 10;

var random : RandomNumberGenerator = RandomNumberGenerator.new();
var is_railing : bool;
var rail_position : Vector2;
var rail_speed : int;
