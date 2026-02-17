extends Control

@onready var play_button = $Panel/PlayButton
@onready var canvas_layer = get_tree().current_scene.get_node("CanvasLayer")


func _on_play_button_pressed() -> void:
	var account_menu= preload("res://scene/ui/account_menu.tscn").instantiate()
	account_menu.back_pressed.connect(show_menu)
	hide_menu()
	canvas_layer.add_child(account_menu)
	
func hide_menu():
	visible = false
func show_menu():
	visible = true


func _on_exit_button_pressed() -> void:
	get_tree().quit()
