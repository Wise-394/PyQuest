extends Area2D

@export var question_id: int = 0
@export var child_nodes: Array[Node]
@export var is_explanation:bool
@onready var label: Label = $Label
@onready var player: CharacterBody2D = get_tree().current_scene.get_node("Player")

var editor_instance: Control = null
var explanation_instance: Control = null
var is_player_in_range := false

func _ready() -> void:
	label.visible = false
	set_process(false)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("toggle_editor") and is_player_in_range:
		if question_id != 0:
			_open_editor()
		else:
			push_warning("CodingZone: Please assign a question ID.")

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		is_player_in_range = true
		label.visible = true
		set_process(true)

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		is_player_in_range = false
		label.visible = false
		set_process(false)

func _open_editor() -> void:
	if editor_instance:
		return

	var editor_scene = preload("res://scene/ui/code_editor.tscn")
	editor_instance = editor_scene.instantiate()

	var canvas_layer = get_tree().current_scene.get_node("UI/CanvasLayer")
	canvas_layer.add_child(editor_instance)

	editor_instance.open_editor(question_id)
	editor_instance.code_editor_closed.connect(_on_editor_closed)

	player.state_machine.change_state("CodeEditState")

# -------------------------------
# When code editor is closed
# -------------------------------
func _on_editor_closed(is_correct: bool, explanation) -> void:
	# Only show explanation UI if the answer is correct
	if is_correct and is_explanation:
		var explanation_scene = preload("res://scene/ui/explanation.tscn")
		explanation_instance = explanation_scene.instantiate()

		var canvas_layer = get_tree().current_scene.get_node("UI/CanvasLayer")
		canvas_layer.add_child(explanation_instance)
		
		explanation_instance.initialize(explanation)
		explanation_instance.explanation_closed.connect(_on_explanation_close)

	else:
		# If incorrect, immediately activate children (or do nothing if needed)
		_activate_children(is_correct)

	# Cleanup editor
	if editor_instance:
		editor_instance.queue_free()
		editor_instance = null

# -------------------------------
# When explanation is closed
# -------------------------------
func _on_explanation_close() -> void:
	# Activate child nodes only after explanation closes
	_activate_children(true)

	# Cleanup explanation
	if explanation_instance:
		explanation_instance.call_deferred("free")
		explanation_instance = null

# -------------------------------
# Helper: activate child nodes
# -------------------------------
func _activate_children(is_correct: bool) -> void:
	player.state_machine.change_state("idlestate")
	if is_correct:
		for child in child_nodes:
			if child and child.has_method("activate_process"):
				child.activate_process()
