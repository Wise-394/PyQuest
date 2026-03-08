extends Control

const LEADERBOARD_ITEM := preload("res://multiplayer/scene/ui/leaderboard_item.tscn")

@onready var vbox : VBoxContainer = $CanvasLayer/LeaderboardsPanel/ScrollContainer/VBoxContainer

func _ready() -> void:
	var scores : Dictionary = SaveLoad.final_scores
	var sorted = []
	for key in scores.keys():
		if int(key) == 1:
			continue
		sorted.append(scores[key])
	sorted.sort_custom(func(a, b): return a["points"] > b["points"])
	
	for player in sorted:
		var item := LEADERBOARD_ITEM.instantiate()
		vbox.add_child(item)
		item.get_node("MarginContainer/HBoxContainer/PlayerLabel").text = player["username"]
		item.get_node("MarginContainer/HBoxContainer/PointsLabel").text = str(player["points"])

func _on_exit_button_pressed() -> void:
	SaveLoad.final_scores = {}
	get_tree().change_scene_to_file("res://scene/save/loading_screen.tscn")
