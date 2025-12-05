extends Area2D

@onready var label: Label = $Label
func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		label.visible	= true


func _on_body_exited(body: Node2D) -> void:
		if body.name == "Player":
			label.visible = false	
