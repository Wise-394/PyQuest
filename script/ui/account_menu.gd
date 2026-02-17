extends Control

signal back_pressed
func _on_button_pressed() -> void:
	back_pressed.emit()
	queue_free()

func toggle_visibility():
	visible = !visible
