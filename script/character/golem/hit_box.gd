extends Area2D



var player_in_hitbox: CharacterBody2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_hitbox = body




func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_hitbox = null
