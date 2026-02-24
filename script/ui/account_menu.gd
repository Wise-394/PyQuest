extends Control

@export var save_files: Array[Panel]

func _ready() -> void:
	for save in save_files:
		save.refresh()

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/lvl/main_menu.tscn")
