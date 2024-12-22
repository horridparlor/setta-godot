extends Node2D
class_name DecklistFilters

signal close();
signal submit_filters(filters);

const OPEN_WAIT : float = 0.2;
const CLOSE_WAIT : float = 0.1;
const EXTRA_WAIT : float = 0.1;

var is_opening : bool;
var is_closing : bool;
var is_active : bool;
var init_filters : CardFilters;

func init(filters : CardFilters) -> void:
	pass;

func toggle_active(value : bool = true) -> void:
	is_active = value;

func on_close() -> void:
	pass;
