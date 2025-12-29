extends Control

func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()



func _on_exit_button_pressed() -> void:
	SaveLoad.current_level = 0
	get_tree().change_scene_to_file("res://scene/save/loading_screen.tscn")
	
