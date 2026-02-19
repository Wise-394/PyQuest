extends Control

signal back_pressed
@export var save_files : Array[Panel]
func _on_button_pressed() -> void:
	back_pressed.emit()
	queue_free()

func _ready() -> void:
	for save in save_files:
		save.refresh()
		
func toggle_visibility():
	visible = !visible
