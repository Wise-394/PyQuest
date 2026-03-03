extends Control

var level: int = 0

@onready var level_label = $Panel/LevelLabel
@onready var title_label = $Panel/LevelLabel/TitleLabel
@onready var highscore_label = $Panel/HighscoreLabel
@onready var description_label = $Panel/ScrollContainer/MarginContainer/RichTextLabel

func _ready() -> void:
	description_label.meta_clicked.connect(_on_meta_clicked)
	level_label.text = "Level " + str(level)
	var level_points: Dictionary = SaveLoad.data.get("level_points", {})
	highscore_label.text = "HighScore: " + "%03d" % level_points.get(str(level), 0)
	for lvl_data in LevelList.levels:
		if lvl_data["level"] == level:
			title_label.text = lvl_data["title"]
			_load_description(lvl_data["description_file"])
			break

func _load_description(file_path: String) -> void:
	if file_path == "":
		description_label.text = "No description available."
		return
	
	var full_path = "res://" + file_path
	print("Trying to load: ", full_path)
	
	var file = FileAccess.open(full_path, FileAccess.READ)
	if file:
		description_label.text = file.get_as_text()
		file.close()
	else:
		print("Error: ", FileAccess.get_open_error())
		description_label.text = "Description could not be loaded."

func _on_meta_clicked(meta) -> void:
	OS.shell_open(str(meta))

func _on_close_button_pressed() -> void:
	queue_free()

func _on_play_button_pressed() -> void:
	SaveLoad.current_lvl_pts = 0
	SaveLoad.current_level = level
	queue_free()
	get_tree().change_scene_to_file("res://scene/save/loading_screen.tscn")
