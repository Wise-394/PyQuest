extends Control


signal info_closed

func _on_button_pressed() -> void:
	info_closed.emit()
	queue_free()
