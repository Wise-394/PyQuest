extends Control
@onready var label := $CanvasLayer/RichTextLabel


func _ready():
	label.position.y = get_viewport().size.y

func _process(delta):
	label.position.y -= 50 * delta


func _on_exit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/save/loading_screen.tscn")
