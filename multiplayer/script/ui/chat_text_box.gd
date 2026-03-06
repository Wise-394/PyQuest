extends LineEdit

func _ready() -> void:
	focus_entered.connect(_on_focus_entered)
	focus_exited.connect(_on_focus_exited)
	text_submitted.connect(_on_text_submitted)  # built in signal for enter key

func _on_focus_entered() -> void:
	_get_local_player().state_machine.change_state("pausestate")

func _on_focus_exited() -> void:
	_get_local_player().state_machine.change_state("idlestate")

func _on_text_submitted(message: String) -> void:
	message = message.strip_edges()
	if message != "":
		var game_world := get_tree().root.get_node("GameWorld")
		if multiplayer.is_server():
			game_world.chat(multiplayer.get_unique_id(), message)
		else:
			game_world.chat.rpc_id(1, multiplayer.get_unique_id(), message)
		text = ""
	release_focus()

func _get_local_player() -> Node:
	var id := multiplayer.get_unique_id()
	return get_tree().root.get_node("GameWorld/Players/%d" % id)
