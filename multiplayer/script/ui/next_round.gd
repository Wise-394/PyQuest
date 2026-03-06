extends Control

@onready var player_left_label : Label = $Panel/PlayerLeftLabel

func _ready() -> void:
	var game_world := get_tree().root.get_node("GameWorld")
	game_world.submission_updated.connect(_refresh_count)
	_refresh_count()

func _refresh_count() -> void:
	var game_world  := get_tree().root.get_node("GameWorld")
	var total       = game_world.players.size() - 1
	var checked     = game_world.checked_players.size()
	var not_checked = total - checked
	if not_checked == 0:
		player_left_label.text = "All players have been checked!\nProceed to next round?"
	else:
		player_left_label.text = "there are still %d player(s)\nthat haven't been checked/Submitted" % not_checked

func _on_no_button_pressed() -> void:
	queue_free()

func _on_yes_button_pressed() -> void:
	var game_world := get_tree().root.get_node("GameWorld")
	game_world.next_round()
	queue_free()
