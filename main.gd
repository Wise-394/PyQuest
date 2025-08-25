extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var resource = load("res://dialogue/intro.dialogue")
	DialogueManager.show_dialogue_balloon(resource, "start")
	
	# reassign nodes to global script
	GlobalScript.coords = $gui/coords
	GlobalScript.console = $gui/Console
	GlobalScript.coords_label = $gui/coords/coordinates
	GlobalScript.skills_terminal = $gui/skills_terminal

	# ---Signal connections---
	if not DialogueManager.dialogue_started.is_connected(GlobalScript._on_dialogue_started):
		DialogueManager.dialogue_started.connect(GlobalScript._on_dialogue_started)

	if not DialogueManager.dialogue_ended.is_connected(GlobalScript._on_dialogue_ended):
		DialogueManager.dialogue_ended.connect(GlobalScript._on_dialogue_ended)

	if not GlobalScript.skills_terminal.skills_terminal_state_changed.is_connected(GlobalScript._on_skills_terminal_state_changed):
		GlobalScript.skills_terminal.skills_terminal_state_changed.connect(GlobalScript._on_skills_terminal_state_changed)

	if not GlobalScript.console.console_opened.is_connected(GlobalScript._on_console_opened):
		GlobalScript.console.console_opened.connect(GlobalScript._on_console_opened)

	if not GlobalScript.console.console_closed.is_connected(GlobalScript._on_console_closed):
		GlobalScript.console.console_closed.connect(GlobalScript._on_console_closed)
