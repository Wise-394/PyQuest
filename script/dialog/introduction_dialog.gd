extends Area2D

signal dialogue_finished

func _ready() -> void:
	DialogueManager.dialogue_ended.connect(_on_dialog_finished)
	
func open_dialog():
	var resource = load("res://dialog/introduction.dialogue")
	DialogueManager.show_dialogue_balloon(resource, "start")
	
func _on_dialog_finished(_resource):
	emit_signal("dialogue_finished")
