extends StaticBody2D



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.character_damaged(20)

func activate_process():
	queue_free()
	
