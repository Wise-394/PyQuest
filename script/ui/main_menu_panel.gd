extends Control


@onready var animation: AnimationPlayer = $"../../AnimationPlayer"
@onready var color_rect: ColorRect = $"../ColorRect"
@onready var timer := $"../../Timer"
func _ready() -> void:
	color_rect.visible = false
	color_rect.color = Color.TRANSPARENT
	
func _on_play_button_pressed() -> void:
	timer.start()

func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_timer_timeout() -> void:
	color_rect.visible = true
	animation.play("fade_in")


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	get_tree().change_scene_to_file("res://scene/ui/account_menu.tscn")
