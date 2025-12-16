extends Control


signal chest_closed



func _on_close_pressed() -> void:
	chest_closed.emit()
	call_deferred("close")
	
func close():
	queue_free()
