extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		call_deferred("picked_up")

func picked_up():
	var coin_label = get_tree().current_scene.get_node("UI/CanvasLayer/CoinLabel")
	coin_label.picked_up_coins() 
	queue_free()
