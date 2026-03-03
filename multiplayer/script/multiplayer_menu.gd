extends Control

func _on_player_button_pressed() -> void:
	get_tree().change_scene_to_file("res://multiplayer/scene/join_screen.tscn")

func _on_host_buttton_pressed() -> void:
	var peer := ENetMultiplayerPeer.new()
	peer.create_server(7777)
	multiplayer.multiplayer_peer = peer
	get_tree().change_scene_to_file("res://multiplayer/scene/lobby.tscn")
