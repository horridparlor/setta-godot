extends Node2D
class_name DecklistMetaData

signal name_changed(message);
signal roll_deck(direction);
signal save();
signal delete();

const VALID_SPRITE_PATH : String = "res://Assets/Icons/Common/validation/valid.png";
const INVALID_SPRITE_PATH : String = "res://Assets/Icons/Common/validation/invalid.png";

var is_active : bool;

func eat_decklist(decklist : DecklistData) -> void:
	pass;

func toggle_active(value : bool = true) -> void:
	is_active = value;

func toggle_valid(value : bool = true) -> void:
	pass;

func force_unsubmitted_updates() -> void:
	pass;
