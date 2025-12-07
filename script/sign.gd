extends Area2D

@onready var label: Label = $Label
@export var label_text: String
var is_label_visible = false

func _ready() -> void:
	label.text = label_text

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		toggle_label()


func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		toggle_label()


func toggle_label():
	if is_label_visible:
		label.visible = false
		is_label_visible = false
	else:
		label.visible = true
		is_label_visible = true
