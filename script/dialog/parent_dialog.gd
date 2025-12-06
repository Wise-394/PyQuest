extends Node
class_name Parent_Dialog

signal dialogue_finished

func _ready() -> void:
	DialogueManager.dialogue_ended.connect(_on_dialog_finished)
	
func open_dialog():
	pass
	
func _on_dialog_finished(_resource):
	emit_signal("dialogue_finished")
