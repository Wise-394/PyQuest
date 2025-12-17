extends Area2D


@onready var label: Label = $Label
@export var question: String = "question"
@export var answer: String
@onready var canvas_layer: CanvasLayer = get_tree().current_scene.get_node("UI/CanvasLayer")
@onready var chest = preload("res://scene/ui/chest_ui.tscn")

var _is_ui_visible = false
var _is_label_visible = false
func _ready() -> void:
	_set_interaction_available(false)
	
func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("interact") and _is_label_visible and not _is_ui_visible):
		open_chest()
		
func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		_set_interaction_available(true)
		
func open_chest():
	_is_ui_visible = true
	var chest_instance = chest.instantiate()
	chest_instance.chest_closed.connect(_finalize)
	canvas_layer.add_child(chest_instance)
	chest_instance.open_question(question)

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		_set_interaction_available(false)

func _set_interaction_available(value: bool) -> void:
	_is_label_visible = value
	label.visible = value
	set_process(value)

func _finalize(is_correct):
	if not is_correct:
		_is_ui_visible = false
