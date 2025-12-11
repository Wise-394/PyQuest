extends Control

signal explanation_closed

func _on_close_pressed() -> void:
	explanation_closed.emit()
	call_deferred("free")
