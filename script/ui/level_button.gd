extends Button

@export var level:int = 0
func _ready() -> void:
	text = str(level)



func _on_pressed() -> void:
	SaveLoad.current_level = level
	get_tree().change_scene_to_file("res://scene/save/loading_screen.tscn")
