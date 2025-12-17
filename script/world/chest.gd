extends Area2D

@onready var label: Label = $Label
@onready var animated_sprite = $AnimatedSprite2D
@onready var canvas_layer: CanvasLayer = get_tree().current_scene.get_node("UI/CanvasLayer")

@export_multiline var question: String = "question"
@export var answer: Array[String]

const CHEST_UI = preload("res://scene/ui/chest_ui.tscn")

var is_locked = true
var is_ui_visible = false
var is_label_visible = false
var player: CharacterBody2D

func _ready() -> void:
	_set_interaction_available(false)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and is_label_visible and not is_ui_visible:
		_open_chest()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and is_locked:
		player = body
		_set_interaction_available(true)

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		_set_interaction_available(false)

func _open_chest() -> void:
	is_ui_visible = true
	player.state_machine.change_state("pausestate")
	
	var chest_instance = CHEST_UI.instantiate()
	chest_instance.chest_closed.connect(_on_chest_closed)
	canvas_layer.add_child(chest_instance)
	chest_instance.open_chest_ui(question, answer)

func _on_chest_closed(is_correct: bool) -> void:
	if is_correct:
		is_locked = false
		_set_interaction_available(false)
		print("do something")
		animated_sprite.play("open")
	
	is_ui_visible = false
	player.state_machine.go_idle()

func _set_interaction_available(value: bool) -> void:
	is_label_visible = value
	label.visible = value
	set_process(value)
