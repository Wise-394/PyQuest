extends Node

signal dialogue_opened
signal dialogue_closed
signal console_opened
signal console_closed

var is_dialogue_open: bool = false
var is_console_open: bool = false

func _ready() -> void:
	DialogueManager.dialogue_started.connect(_on_dialogue_started)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	# You’ll also connect console signals here later

func _on_dialogue_started(_res):
	is_dialogue_open = true
	dialogue_opened.emit()

func _on_dialogue_ended(_res):
	is_dialogue_open = false
	dialogue_closed.emit()
