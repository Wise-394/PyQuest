extends Area2D

@onready var label: Label = $Label
@export var label_text: String
var isLabelVisible = false

func _ready() -> void:
	label.text = label_text

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		toggle_label()


func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		toggle_label()


func toggle_label():
	if isLabelVisible:
		label.visible = false
		isLabelVisible = false
	else:
		label.visible = true
		isLabelVisible = true
