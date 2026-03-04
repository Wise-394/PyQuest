extends Control


func _get_host_player() -> Node:
	return get_tree().root.get_node("GameWorld/Players/1")

func _on_close_button_pressed() -> void:
	var player = _get_host_player()
	player.state_machine.change_state("idlestate")
	queue_free()
