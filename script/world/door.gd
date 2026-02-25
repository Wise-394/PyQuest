extends Area2D


@onready var label := $Label
@export var level: int
@export_file("*.tscn") var level_to_go: String
func _ready() -> void:
	label.visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_editor") and label.visible:
		SaveLoad.current_level = level
		get_tree().change_scene_to_file(level_to_go)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group('player'):
		label.visible = true


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group('player'):
		label.visible = false
