extends Button
@onready var canvas_layer = get_tree().current_scene.get_node("UI/CanvasLayer")

func _on_pressed() -> void:
	get_tree().paused = true
	instantiate_pause_menu()

func unpause():
	get_tree().paused = false
	
func instantiate_pause_menu():
	var pause_menu = preload("res://scene/ui/pause_menu.tscn").instantiate()
	pause_menu.resume.connect(unpause)
	canvas_layer.add_child(pause_menu)
