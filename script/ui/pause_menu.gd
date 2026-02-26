extends Control


signal resume

func _on_resume_button_pressed() -> void:
	print("pressed")
	resume.emit()
	call_deferred("free")


func _on_exit_button_pressed() -> void:
	get_tree().paused = false
	SaveLoad.current_level = 0
	SaveLoad.current_lvl_pts = 0
	get_tree().change_scene_to_file("res://scene/save/loading_screen.tscn")
