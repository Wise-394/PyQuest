extends Node

# ===============================
#           NODES
# ===============================
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var color_rect: ColorRect = $ColorRect

# ===============================
#        CONFIGURATION
# ===============================
@export var level_folder: String = "res://scene/lvl/"
@export var level_selection_scene: String = "level_selection.tscn"

# ===============================
#           READY
# ===============================
func _ready() -> void:
	color_rect.color = Color.TRANSPARENT

# ===============================
#         TRANSITION
# ===============================
func _on_timer_timeout() -> void:
	animation.play("fade_in")

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	change_scene()

# ===============================
#        SCENE LOADING
# ===============================
func change_scene() -> void:
	var current_level: int = SaveLoad.current_level
	var scene_path: String

	# Main menu
	if current_level == 0:
		scene_path = level_folder + level_selection_scene
	else:
		scene_path = "%slvl_%d.tscn" % [level_folder, current_level]

	# Safety check
	if not ResourceLoader.exists(scene_path):
		push_error("Level %d not found at path: %s" % [current_level, scene_path])
		return

	get_tree().change_scene_to_file(scene_path)
