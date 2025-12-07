#this npc needs a dialog children
extends Area2D

@onready var label: Label = $Label
@export var dialog: Node

var _is_label_visible := false
var _is_dialog_active := false
var player: CharacterBody2D

func _ready() -> void:
	_set_label_visibility_and_process(false)
	dialog.dialogue_finished.connect(_on_dialog_finished)
	set_process(false)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("open_dialog") \
	and _is_label_visible and not _is_dialog_active:
		_open_dialog()


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player = body
		_set_label_visibility_and_process(true)


func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		_set_label_visibility_and_process(false)


# -----------------------
#   Helper Functions
# -----------------------

func _set_label_visibility_and_process(value: bool) -> void:
	_is_label_visible = value
	label.visible = value
	set_process(value)


func _open_dialog() -> void:
	_is_dialog_active = true
	dialog.open_dialog()

	if player:
		player.state_machine.change_state("dialogstate")


func _on_dialog_finished() -> void:
	if player:
		player.state_machine.go_idle()

	_is_dialog_active = false
