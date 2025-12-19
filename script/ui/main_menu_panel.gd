extends Control

@onready var play_button = $Panel/PlayButton
@onready var canvas_layer = get_tree().current_scene.get_node("CanvasLayer")


func _on_play_button_pressed() -> void:
	var level_selection = preload("res://scene/ui/level_selection.tscn").instantiate()
	level_selection.back_pressed.connect(show_menu)
	hide_menu()
	canvas_layer.add_child(level_selection)
	
	
func hide_menu():
	visible = false
func show_menu():
	visible = true
