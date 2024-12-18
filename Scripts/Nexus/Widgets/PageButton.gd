extends PageButton

@onready var active_panel : Panel = $ActivePanel;
@onready var sprite : Sprite2D = $Control/Sprite2D;
@onready var title : Label = $Label;

func _ready() -> void:
	toggle_active(false);

func init(page : NexusEnums.NexusPages, sprite_path : String) -> void:
	nexus_page = page;
	sprite.texture = load(sprite_path);
	title.text = NexusEnums.translate_nexus_page(nexus_page);

func toggle_active(state : bool = true) -> void:
	var opacity : float = TITLE_ACTIVE_OPACITY if state else TITLE_INACTIVE_OPACITY;
	active_panel.visible = state;
	sprite.modulate.a = opacity;
	title.modulate.a = opacity;

func _on_button_triggered() -> void:
	emit_signal("pressed", self);
