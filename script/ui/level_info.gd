extends Control
var level: int = 0
@onready var level_label = $Panel/LevelLabel
@onready var title_label = $Panel/LevelLabel/TitleLabel
@onready var highscore_label = $Panel/HighscoreLabel
@onready var description_label = $Panel/ScrollContainer/MarginContainer/RichTextLabel

func _ready() -> void:
	level_label.text = "Level " + str(level)
	
	# Find the matching level data from LevelList
	for lvl_data in LevelList.levels:
		if lvl_data["level"] == level:
			title_label.text = lvl_data["title"]
			description_label.text = lvl_data["description"]
			break

func _on_close_button_pressed() -> void:
	queue_free()

func _on_play_button_pressed() -> void:
	SaveLoad.current_lvl_pts = 0
	SaveLoad.current_level = level
	queue_free()
	get_tree().change_scene_to_file("res://scene/save/loading_screen.tscn")
