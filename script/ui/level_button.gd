extends Button

@export var level:int = 0
@export_file("*.tscn") var level_to_go: String
func _ready() -> void:
	text = str(level)



func _on_pressed() -> void:
	get_tree().change_scene_to_file(level_to_go)
