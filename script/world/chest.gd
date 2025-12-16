extends Area2D


@onready var label: Label = $Label
@export var question: String = "question"
@export var answer: String
@onready var canvas_layer: CanvasLayer = get_tree().current_scene.get_node("UI/CanvasLayer")
var chest_ui: Control
var _is_label_visible = false
func _ready() -> void:
	_set_interaction_available(false)

func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("interact") and _is_label_visible and not chest_ui):
		open_chest()
		
func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		_set_interaction_available(true)
		
func open_chest():
	chest_ui = preload("res://scene/ui/chest_ui.tscn").instantiate()
	chest_ui.open_question(question)
	canvas_layer.add_child(chest_ui)


func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		_set_interaction_available(false)

func _set_interaction_available(value: bool) -> void:
	_is_label_visible = value
	label.visible = value
	set_process(value)
