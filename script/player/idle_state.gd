extends State
class_name IdleState

var character: CharacterBody2D
var sprite: AnimatedSprite2D


func enter():
	_init_references()
	sprite.play("idle")


func physics_update(_delta):
	_check_floor_state()
	_handle_movement_input()
	_apply_idle_friction()
	character.move_and_slide()


func handle_input(_event):
	if Input.is_action_just_pressed("jump"):
		state_machine.change_state("jumpstate")


# ============================
#     SUB FUNCTIONS
# ============================

func _init_references():
	character = state_machine.player
	sprite = character.player_sprite


func _check_floor_state():
	if not character.is_on_floor():
		state_machine.change_state("jumpstate")
		return


func _handle_movement_input():
	var direction = Input.get_axis("move_left", "move_right")

	if direction != 0:
		state_machine.change_state("walkstate")
		return


func _apply_idle_friction():
	character.velocity.x = lerp(character.velocity.x, 0.0, 0.25)
