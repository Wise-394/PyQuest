#goodluck future self if ever one day you need to modify this code

# Dear programmer:
# When I wrote this code, only god and I knew how it worked.
# Now, only god knows it!

# Therefore, if you are trying to modify, optimize or refactor
# this script and it fails (most surely),
# please increase this counter as a
# warning for the next programming attempting this script:

#total_hours_wasted_here = 36

# FLOW VISUALIZATION (for easy modifaction, GOODLUCK!!!)
# ============================================================
#
# Player enters zone:
#   → Show label, enable input.
#
# Player presses toggle_editor:
#   → Spawn CodeEditor (CanvasLayer), Player enters "CodeEditState".
#
# CodeEditor:
#   open_editor() loads question.
#   Run → submits code to API.
#   Close → emits code_editor_closed(is_correct, explanation) and frees itself.
#
# CodingZone receives close signal:
#   - If incorrect: finalize(false) → return player to idle.
#   - If correct & no explanation: finalize(true) → activate child nodes.
#   - If correct & explanation required: spawn Explanation UI.
#
# Explanation UI:
#   Close → emits explanation_closed → finalize(true) → activate child nodes.
#
# Finalization:
#   → Player returns to "idlestate".
#   → If correct: mark zone completed, hide label, disable further input.
#
# ============================================================

extends Area2D

@export var question_id: int = 0
@export var child_nodes: Array[Node]
@export var is_explanation: bool = false

@onready var label: Label = $Label
@onready var player: CharacterBody2D = get_tree().current_scene.get_node("Player")
@onready var canvas_layer: CanvasLayer = get_tree().current_scene.get_node("UI/CanvasLayer")
@onready var zone_remaining: Label = get_tree().current_scene.get_node("UI/CanvasLayer/ZoneRemaining")
@onready var particles: CPUParticles2D = $CPUParticles2D
@onready var collision: CollisionShape2D = $CollisionShape2D
var is_player_in_range := false
var is_completed := false

var editor_instance: Control = null
var explanation_instance: Control = null


# ----------------------------------------------------------
# SETUP
# ----------------------------------------------------------
func _ready() -> void:
	var shape = collision.shape as RectangleShape2D
	if shape:
		particles.position = collision.position 
		particles.emission_rect_extents = shape.size * 0.5
		particles.local_coords = true

	label.visible = false
	set_process(false)

# ----------------------------------------------------------
# PLAYER INPUT
# ----------------------------------------------------------
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("toggle_editor") and is_player_in_range:
		_open_editor()


# ----------------------------------------------------------
# BODY ENTER/EXIT
# ----------------------------------------------------------
func _on_body_entered(body: Node2D) -> void:
	if body == player and not is_completed:
		_set_zone_active(true)

func _on_body_exited(body: Node2D) -> void:
	if body == player:
		_set_zone_active(false)

func _set_zone_active(active: bool) -> void:
	is_player_in_range = active
	label.visible = active
	set_process(active)


# ----------------------------------------------------------
# EDITOR FLOW
# ----------------------------------------------------------
func _open_editor() -> void:
	if editor_instance or is_completed:
		return
	
	if question_id == 0:
		push_warning("CodingZone: question_id not set!")
		return
	
	editor_instance = preload("res://scene/ui/code_editor.tscn").instantiate()
	canvas_layer.add_child(editor_instance)

	editor_instance.code_editor_closed.connect(_on_editor_closed)
	editor_instance.open_editor(question_id)

	player.state_machine.change_state("CodeEditState")


func _on_editor_closed(is_correct: bool, explanation: String) -> void:
	editor_instance = null

	if is_correct and is_explanation:
		_open_explanation(explanation)
	else:
		_finalize(is_correct)


# ----------------------------------------------------------
# EXPLANATION FLOW
# ----------------------------------------------------------
func _open_explanation(explanation: String) -> void:
	explanation_instance = preload("res://scene/ui/explanation.tscn").instantiate()
	canvas_layer.add_child(explanation_instance)

	explanation_instance.explanation_closed.connect(_on_explanation_closed)
	explanation_instance.initialize(explanation)


func _on_explanation_closed() -> void:
	explanation_instance = null
	_finalize(true)


# ----------------------------------------------------------
# FINAL STATE
# ----------------------------------------------------------
func _finalize(is_correct: bool) -> void:
	player.state_machine.change_state("idlestate")

	if is_correct:
		is_completed = true
		_activate_children()
		_set_zone_active(false)
		particles.disable()
		zone_remaining.update_count()


func _activate_children() -> void:
	for child in child_nodes:
		if child and child.has_method("activate_process"):
			child.activate_process()
