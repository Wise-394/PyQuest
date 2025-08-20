extends Area2D

@export var console: CanvasLayer
@onready var label = $Label

var player_inside = false

func _process(_delta: float) -> void:
	if player_inside and Input.is_action_just_pressed("open_console"):
		console.open_console()

func _on_body_entered(body: Node2D) -> void:
	if body.name != "player":
		return
	player_inside = true
	label.visible = true

func _on_body_exited(body: Node2D) -> void:
	if body.name != "player":
		return
	player_inside = false
	label.visible = false
