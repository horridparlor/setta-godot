extends ActionHint

@onready var label : RichTextLabel = $MarginContainer/VBoxContainer/RichTextLabel;

func set_text(text : String) -> void:
	label.text = text;
