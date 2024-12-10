extends CancelButton

func _on_button_pressed() -> void:
	emit_signal("pressed");
