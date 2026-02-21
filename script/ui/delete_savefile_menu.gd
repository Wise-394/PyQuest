extends Control




func _on_no_button_pressed() -> void:
	queue_free()


func _on_yes_button_pressed() -> void:
	SaveLoad.delete_slot(SaveLoad.active_slot)
	get_tree().change_scene_to_file("res://scene/lvl/main_menu.tscn")
