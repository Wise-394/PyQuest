extends Node
signal dialogue_finished 
@export var dialog: DialogueResource
func _ready() -> void:
	DialogueManager.dialogue_ended.connect(_on_dialog_finished)
	
func open_dialog():
	DialogueManager.show_dialogue_balloon(dialog, "start")
	

	
func _on_dialog_finished(_resource):
	emit_signal("dialogue_finished")
