extends Button

func _ready() -> void:
	visible = multiplayer.is_server()

func _on_pressed() -> void:
	get_tree().get_root().get_node("GameWorld").end_game()
