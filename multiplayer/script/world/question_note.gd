extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.is_multiplayer_authority() and not body.get_multiplayer_authority() == 1:
			body.question_discovered(true)
			
