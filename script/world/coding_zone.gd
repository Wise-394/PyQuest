#goodluck future self if ever one day you need to modify this code

# Dear programmer:
# When I wrote this code, only god and I knew how it worked.
# Now, only god knows it!

# Therefore, if you are trying to modify, optimize or refactor
# this script and it fails (most surely),
# please increase this counter as a
# warning for the next programming attempting this script:

#total_hours_wasted_here = 24

#flow visualization for easy modifications
#[CodingZone] Player enters → _on_body_entered() → label shows
#[CodingZone] Press toggle_editor → _open_code_editor() → spawns editor
#[CodeEditor] open_editor() → question_api.get_question() → shows question
#[CodeEditor] Player writes code → clicks Run → _on_run_pressed() → question_api.post_question()
#[CodeEditor] Player clicks Close → _on_close_pressed() → emits code_editor_closed(is_correct, explanation)
#
#[CodingZone] _on_code_editor_closed() receives signal:
#• Wrong answer → _finalize_interaction(false) → back to idle
#• Correct + no explanation → _finalize_interaction(true) → _activate_child_nodes()
#• Correct + has explanation → _open_explanation() → spawns explanation UI
#
#[Explanation] Player reads → clicks Close → emits explanation_closed
#[CodingZone] _on_explanation_closed() → _finalize_interaction(true) → _activate_child_nodes()
extends Area2D

# ============================================================================
# EXPORTS
# ============================================================================
@export var question_id: int = 0
@export var child_nodes: Array[Node]
@export var is_explanation: bool

# ============================================================================
# NODE REFERENCES
# ============================================================================
@onready var label: Label = $Label
@onready var player: CharacterBody2D = get_tree().current_scene.get_node("Player")
@onready var canvas_layer: CanvasLayer = get_tree().current_scene.get_node("UI/CanvasLayer")

# ============================================================================
# STATE
# ============================================================================
var is_player_in_range := false
var editor_instance: Control = null
var explanation_instance: Control = null
var is_completed:bool = false
# ============================================================================
# LIFECYCLE
# ============================================================================
func _ready() -> void:
	_initialize_ui()

func _process(_delta: float) -> void:
	_handle_input()

# ============================================================================
# INITIALIZATION
# ============================================================================
func _initialize_ui() -> void:
	label.visible = false
	set_process(false)

# ============================================================================
# INPUT HANDLING
# ============================================================================
func _handle_input() -> void:
	if Input.is_action_just_pressed("toggle_editor") and is_player_in_range:
		_try_open_editor()

func _try_open_editor() -> void:
	if question_id == 0:
		push_warning("CodingZone: Please assign a question ID.")
		return
	
	_open_code_editor()

# ============================================================================
# PLAYER DETECTION
# ============================================================================
func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not is_completed:
		_set_player_in_range(true)

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		_set_player_in_range(false)

func _set_player_in_range(in_range: bool) -> void:
	is_player_in_range = in_range
	label.visible = in_range
	set_process(in_range)

# ============================================================================
# CODE EDITOR FLOW
# ============================================================================
func _open_code_editor() -> void:
	if editor_instance:
		return
	
	editor_instance = _instantiate_editor()
	editor_instance.open_editor(question_id)
	editor_instance.code_editor_closed.connect(_on_code_editor_closed)
	_set_player_state("CodeEditState")

func _instantiate_editor() -> Control:
	var editor_scene = preload("res://scene/ui/code_editor.tscn")
	var instance = editor_scene.instantiate()
	canvas_layer.add_child(instance)
	return instance

func _on_code_editor_closed(is_correct: bool, explanation: String) -> void:
	_cleanup_editor()
	
	if is_correct and is_explanation:
		_open_explanation(explanation)
	else:
		_finalize_interaction(is_correct)

func _cleanup_editor() -> void:
	if editor_instance:
		editor_instance.queue_free()
		editor_instance = null

# ============================================================================
# EXPLANATION FLOW
# ============================================================================
func _open_explanation(explanation: String) -> void:
	explanation_instance = _instantiate_explanation()
	explanation_instance.initialize(explanation)
	explanation_instance.explanation_closed.connect(_on_explanation_closed)

func _instantiate_explanation() -> Control:
	var explanation_scene = preload("res://scene/ui/explanation.tscn")
	var instance = explanation_scene.instantiate()
	canvas_layer.add_child(instance)
	return instance

func _on_explanation_closed() -> void:
	_cleanup_explanation()
	_finalize_interaction(true)

func _cleanup_explanation() -> void:
	if explanation_instance:
		explanation_instance.call_deferred("free")
		explanation_instance = null

# ============================================================================
# FINALIZATION
# ============================================================================
func _finalize_interaction(is_correct: bool) -> void:
	
	_set_player_state("idlestate")
	
	if is_correct:
		_activate_child_nodes()
		is_completed = true
		_set_player_in_range(false)
		

func _activate_child_nodes() -> void:
	for child in child_nodes:
		if child and child.has_method("activate_process"):
			child.activate_process()

func _set_player_state(state_name: String) -> void:
	player.state_machine.change_state(state_name)

	
