extends Node2D
class_name DecklistMetaData

signal name_changed(message);
signal switch_deck(direction);
signal save();
signal delete();

func eat_decklist(decklist : DecklistData) -> void:
	pass;

func toggle_valid(value : bool = true) -> void:
	pass;

func force_unsubmitted_updates() -> void:
	pass;
