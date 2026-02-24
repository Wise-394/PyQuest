extends Control

@onready var textbox = $CanvasLayer/PassCodeWindow/UserNameTextBox

func _on_cancel_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/ui/account_menu.tscn")

func _on_confirm_button_pressed() -> void:
	if textbox.text == SaveLoad.data['passcode']:
		get_tree().change_scene_to_file("res://scene/lvl/level_selection.tscn")
