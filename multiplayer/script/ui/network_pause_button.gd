extends Button


const PAUSE_MENU := preload("res://multiplayer/scene/ui/network_pause_menu.tscn")

func _on_pressed() -> void:
	var canvas_layer := get_parent()
	if canvas_layer.has_node("PauseMenu"):
		return
	var instance := PAUSE_MENU.instantiate()
	instance.name = "PauseMenu"
	canvas_layer.add_child(instance)
