extends CanvasLayer


signal console_opened
signal console_closed

func _on_button_pressed() -> void:
	close_console()
	
func open_console() -> void:
	visible = true
	console_opened.emit()
func close_console() -> void:
	visible = false
	console_closed.emit()
