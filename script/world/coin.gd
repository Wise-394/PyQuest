extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		call_deferred("picked_up")

func picked_up():
	queue_free()
