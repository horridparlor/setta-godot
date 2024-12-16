extends ShopPage

@onready var label : Label = $DebugLabel;

func _ready() -> void:
	label.text = System.debug_string;
