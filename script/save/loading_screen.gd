extends Node

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var color_rect:ColorRect = $ColorRect
@export var level_scenes: Dictionary = {
	0: "res://scene/lvl/main_menu.tscn",
	1: "res://scene/lvl/lvl_1.tscn",
	2: "res://scene/lvl/lvl_2.tscn",
	3: "res://scene/lvl/lvl_3.tscn",
	4: "res://scene/lvl/lvl_4.tscn"
}
func _ready() -> void:
	color_rect.color = Color.TRANSPARENT
	
func _on_timer_timeout() -> void:
	animation.play("fade_in")

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	change_scene()
	
func change_scene():
	var current_level = SaveLoad.current_level
	
	if level_scenes.has(current_level):
		get_tree().change_scene_to_file(level_scenes[current_level])
	else:
		print("Level ", current_level, " not found!")
