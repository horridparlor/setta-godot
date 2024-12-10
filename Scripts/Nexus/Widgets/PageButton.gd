extends PageButton

@onready var active_panel : Panel = $ActivePanel;
@onready var sprite : Sprite2D = $Label/Sprite2D;
@onready var title : Label = $Label;

func _ready() -> void:
	toggle_active(false);

func init(title_text: String, sprite_path : String) -> void:
	sprite.texture = load(sprite_path);
	title.text = title_text;

func toggle_active(state : bool = true) -> void:
	active_panel.visible = state;
	title.modulate.a = TITLE_ACTIVE_OPACITY if state else TITLE_INACTIVE_OPACITY;

func _on_button_pressed() -> void:
	emit_signal("pressed", self);
