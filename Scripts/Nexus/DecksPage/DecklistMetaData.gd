extends DecklistMetaData

@onready var deck_name_input : TextInput = $DeckName;
@onready var valid_label : Label = $ValidStatus/ValidLabel;

func _ready() -> void:
	deck_name_input.init("Decklist Name", "My new deck");

func eat_decklist(decklist : DecklistData) -> void:
	deck_name_input.set_text(decklist.decklist_name);
	toggle_valid(decklist.is_valid);

func toggle_valid(value : bool = true) -> void:
	valid_label.text = "Valid" if value else "Invalid";

func _on_deck_name_submit_message(message : String) -> void:
	emit_signal("name_changed", message);

func force_unsubmitted_updates() -> void:
	emit_signal("name_changed", deck_name_input.get_text());
