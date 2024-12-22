extends DecklistMetaData

@onready var deck_name_input : TextInput = $DeckName;
@onready var valid_label : Label = $ValidStatus/ValidLabel;
@onready var valid_sprite : Sprite2D = $ValidStatus/ValidSprite;

@onready var save_button : SubmitButton = $Buttons/SaveButton;
@onready var delete_button : SubmitButton = $Buttons/DeleteButton;

func _ready() -> void:
	deck_name_input.init("Decklist Name", "My new deck");
	save_button.init("Save");
	save_button.make_primary();
	delete_button.init("Delete");

func eat_decklist(decklist : DecklistData) -> void:
	deck_name_input.set_text(decklist.decklist_name);
	toggle_valid(decklist.is_valid);

func toggle_valid(value : bool = true) -> void:
	valid_label.text = "Valid" if value else "Invalid";
	valid_sprite.texture = load(VALID_SPRITE_PATH if value else INVALID_SPRITE_PATH);

func _on_deck_name_submit_message(message : String) -> void:
	emit_signal("name_changed", message.strip_edges());

func force_unsubmitted_updates() -> void:
	emit_signal("name_changed", deck_name_input.get_text());

func _on_save_button_pressed() -> void:
	if !is_active:
		return;
	emit_signal("save");

func _on_delete_button_pressed() -> void:
	if !is_active:
		return;
	emit_signal("delete");

func _on_roll_back_triggered() -> void:
	if !is_active:
		return;
	emit_signal("roll_deck", -1);

func _on_roll_forward_triggered() -> void:
	if !is_active:
		return;
	emit_signal("roll_deck");
