# NPC script that shows a label and opens a dialog when the player is nearby
# This script requires a DIALOG node or it won't work
# Plays its dialog script children
# Uses unhandled_input for better input handling
extends Area2D

@onready var open_sprite := $OpenDialogSprite
@export var dialog: Node

var _is_label_visible := false
var _is_dialog_active := false
var player: CharacterBody2D

func _ready() -> void:
	_set_interaction_available(false)
	dialog.dialogue_finished.connect(_on_dialog_finished)
	set_process_unhandled_input(false)

func _unhandled_input(event: InputEvent) -> void:
	# Listen for dialog input when player is nearby
	if event.is_action_pressed("interact") \
	and _is_label_visible and not _is_dialog_active:
		_open_dialog()
		get_viewport().set_input_as_handled()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player = body
		_set_interaction_available(true)

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		_set_interaction_available(false)

# -----------------------
#   Helper Functions
# -----------------------

func _set_interaction_available(value: bool) -> void:
	# Show/hide label and enable/disable input processing
	_is_label_visible = value
	open_sprite.visible = value
	set_process_unhandled_input(value)

func _open_dialog() -> void:
	_is_dialog_active = true
	dialog.open_dialog()
	if player:
		player.state_machine.change_state("pausestate")

func _on_dialog_finished() -> void:
	if player:
		player.state_machine.change_state("idlestate")
	_is_dialog_active = false
