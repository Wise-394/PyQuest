extends Button

@export var level:int = 0
func _ready() -> void:
	text = str(level)
	var highest_level = SaveLoad.data["highest_unlocked_level"] as int
	if highest_level >= level:
		visible = true
	elif level == 1:
		visible = true
	else:
		visible = false


func _on_pressed() -> void:
	SaveLoad.current_level = level
	get_tree().change_scene_to_file("res://scene/save/loading_screen.tscn")
