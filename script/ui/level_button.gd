extends Button

@export var level: int = 0

func _ready() -> void:
	text = str(level)
	var highest_level = SaveLoad.data["highest_unlocked_level"] as int
	if highest_level >= level or level == 1:
		visible = true
	else:
		visible = false

func _on_pressed() -> void:
	var level_info = preload("res://scene/ui/level_info.tscn").instantiate()
	level_info.level = level
	# Add to the CanvasLayer so it renders on top
	get_tree().current_scene.find_child("CanvasLayer").add_child(level_info)
