extends Panel

@export var id: int
@onready var account_menu = $"../.."

func hide_menu():
	account_menu.visible = false

func show_menu():
	account_menu.visible = true

func _on_play_button_pressed() -> void:
	var canvas_layer = get_tree().current_scene.get_node("CanvasLayer")
	var level_selection = preload("res://scene/ui/level_selection.tscn").instantiate()
	level_selection.back_pressed.connect(show_menu)
	account_menu.toggle_visibility()
	canvas_layer.add_child(level_selection)
