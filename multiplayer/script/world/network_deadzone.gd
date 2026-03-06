extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.is_multiplayer_authority():
			var game_world  := get_tree().root.get_node("GameWorld")
			var spawn_index = randi() % game_world.player_spawn_points.get_child_count()
			body.position    = game_world.player_spawn_points.get_child(spawn_index).position
