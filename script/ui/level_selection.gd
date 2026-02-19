extends Control

signal back_pressed
var delete_menu := preload("res://scene/ui/delete_savefile_menu.tscn")
@onready var user_profile_menu := $UserProfileMenu

func _ready() -> void:
	user_profile_menu.delete_button_pressed.connect(_show_delete_menu)
func _on_back_button_pressed() -> void:
	back_pressed.emit()
	call_deferred("free")


func _show_delete_menu():
	var instance = delete_menu.instantiate()
	add_child(instance)
