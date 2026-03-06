extends Control

func _on_resume_button_pressed() -> void:
	queue_free()

func _on_exit_button_pressed() -> void:
	multiplayer.multiplayer_peer = null
	get_tree().change_scene_to_file("res://multiplayer/scene/multiplayer_menu.tscn")
