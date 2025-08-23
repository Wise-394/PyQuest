extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var resource = load("res://dialogue/intro.dialogue")
	DialogueManager.show_dialogue_balloon(resource, "start")
	
