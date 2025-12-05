extends Area2D

@onready var label: Label = $Label
var isVisible = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("open_dialog") and isVisible:
		open_dialog()
			
func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		changeVisibility()


func _on_body_exited(body: Node2D) -> void:
		if body.name == "Player":
			changeVisibility()

func changeVisibility():
	if isVisible == true:
		label.visible = false
		isVisible = false
	else:
		label.visible = true
		isVisible = true

func open_dialog():
	print("dialog open")
