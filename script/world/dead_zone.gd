# Reloads the current scene when the player enters the dead zone
extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		call_deferred("_restart_scene")
		
func _restart_scene():
	get_tree().reload_current_scene()
