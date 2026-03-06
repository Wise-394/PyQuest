extends Control

@onready var player_left_label : Label = $Panel/PlayerLeftLabel

func _ready() -> void:
	var game_world  := get_tree().root.get_node("GameWorld")
	var not_checked := 0
	for id in game_world.players.keys():
		if id == "1":
			continue
		var player = game_world.players_node.get_node_or_null(id)
		if player and not player.is_code_checked:
			not_checked += 1
	player_left_label.text = "there are still %d player(s)\nthat haven't submitted/checked" % not_checked

func _on_no_button_pressed() -> void:
	queue_free()

func _on_yes_button_pressed() -> void:
	var game_world := get_tree().root.get_node("GameWorld")
	game_world.next_round()
	queue_free()
