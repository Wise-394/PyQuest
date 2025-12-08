# Controller script to handle opening/closing the Code Editor UI when the player is nearby.
# Manual process control is used for optimization.
extends Area2D



# -----------------------
# Exported Variables
# -----------------------
@export var question_id: int = 0

# -----------------------
# Node References
# -----------------------
@onready var label: Label = $Label
@onready var player: CharacterBody2D = get_tree().current_scene.get_node("Player")
@onready var code_editor: Control = get_tree().current_scene.get_node("UI/CanvasLayer/CodeEditor")
# -----------------------
# State Variables
# -----------------------
var is_player_in_range: bool = false

# -----------------------
# Godot Callbacks
# -----------------------
func _ready() -> void:
	# Hide the interaction label initially
	label.visible = false
	set_process(false)

	# Connect to the editor's closed signal
	code_editor.code_editor_closed.connect(_on_editor_closed)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("toggle_editor") and is_player_in_range:
		if not code_editor.is_visible():
			if question_id != 0:
				_open_editor()
			else:
				push_warning("Please assign a question ID in the inspector.")


func _on_body_entered(body: Node2D) -> void:
	if _is_player(body):
		_set_interaction_available(true)


func _on_body_exited(body: Node2D) -> void:
	if _is_player(body):
		_set_interaction_available(false)


# -----------------------
# Interaction Methods
# -----------------------
func _set_interaction_available(enabled: bool) -> void:
	is_player_in_range = enabled
	label.visible = enabled
	set_process(enabled)


func _open_editor() -> void:
	code_editor.open_editor(question_id)
	_set_player_dialog_state(true)


func _on_editor_closed(is_answered_and_correct: bool, id: int) -> void:
	_set_player_dialog_state(false)

	if is_answered_and_correct and question_id == id:
		print("Correct answer!")


func _set_player_dialog_state(active: bool) -> void:
	if active:
		player.state_machine.change_state("CodeEditState")
	else:
		player.state_machine.change_state("idlestate")


# -----------------------
# Utility Methods
# -----------------------
func _is_player(body: Node2D) -> bool:
	# Centralized check for player node
	return body.name == "Player"
