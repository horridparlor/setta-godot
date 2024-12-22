extends Node2D
class_name DecklistFilters

signal close();

const OPEN_WAIT : float = 0.2;
const CLOSE_WAIT : float = 0.1;
const EXTRA_WAIT : float = 0.1;

var is_opening : bool;
var is_closing : bool;
var is_active : bool;

func init() -> void:
	pass;

func toggle_active(value : bool = true) -> void:
	is_active = value;
