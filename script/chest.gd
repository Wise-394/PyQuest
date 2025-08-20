extends Area2D

@export var console: CanvasLayer

func _on_body_entered(body: Node2D) -> void:
	if not body.name == "player":
		return
	
	console.visible = true


func _on_body_exited(body: Node2D) -> void:
	if not body.name == "player":
		return
	console.visible = false
