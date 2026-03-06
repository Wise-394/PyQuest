extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.is_multiplayer_authority() and not body.get_multiplayer_authority() == 1:
			if not body.is_question_discovered:
				body.question_discovered(true)
				var game_world := get_tree().root.get_node("GameWorld")
				var username   = game_world.players.get(str(body.get_multiplayer_authority()), {}).get("username", "Player")
				game_world.announce.rpc_id(1, "%s found the question!" % username)
