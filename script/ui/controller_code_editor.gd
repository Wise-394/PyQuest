# controller script to open/close the Code Editor UI when the player is nearby
#process is manually controlled for optimization
extends Area2D

@onready var label: Label = $Label
@onready var player: CharacterBody2D = get_tree().current_scene.get_node("Player")
@onready var code_editor: Control = get_tree().current_scene.get_node("UI/CanvasLayer/CodeEditor")
@export var question_id: int = 0

var is_player_in_range := false

func _ready() -> void:
	if(question_id == 0):
		print(name + " error add question id to inspector")
	label.visible = false
	set_process(false)

	code_editor.code_editor_closed.connect(_on_editor_closed)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("toggle_editor") and is_player_in_range:
		if not code_editor.is_visible():
			_open_editor()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		_set_interaction_available(true)

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		_set_interaction_available(false)
		_close_editor()

# -----------------------
# Helper Functions
# -----------------------
func _set_interaction_available(value: bool):
	is_player_in_range = value
	label.visible = value
	set_process(value)

func _open_editor():
	code_editor.open_editor(question_id)
	_set_player_dialog_state(true)
	
func _close_editor():
	code_editor.close_editor()

func _on_editor_closed():
	_set_player_dialog_state(false)

func _set_player_dialog_state(value: bool):
	if value:
		player.state_machine.change_state("CodeEditState")
	else:
		player.state_machine.change_state("idlestate")
