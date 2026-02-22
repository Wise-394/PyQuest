extends Control

signal back_pressed
var delete_menu := preload("res://scene/ui/delete_savefile_menu.tscn")
var passcode_menu := preload("res://scene/ui/add_passcode_menu.tscn")
@onready var user_profile_menu := $UserProfileMenu

func _ready() -> void:
	user_profile_menu.delete_button_pressed.connect(_show_delete_menu)
	user_profile_menu.add_passcode_pressed.connect(_show_passcode_menu)
func _on_back_button_pressed() -> void:
	back_pressed.emit()
	call_deferred("free")


func _show_delete_menu():
	var instance = delete_menu.instantiate()
	add_child(instance)

func _show_passcode_menu():
	var instance = passcode_menu.instantiate()
	add_child(instance)
	


func _on_button_pressed() -> void:
	SaveLoad.current_level = 21
	get_tree().change_scene_to_file("res://scene/save/loading_screen.tscn")


func _on_achievements_pressed() -> void:
	SaveLoad.current_level = 22
	get_tree().change_scene_to_file("res://scene/save/loading_screen.tscn")
