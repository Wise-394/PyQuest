# WalkState handles the player's walking behavior.
extends PlayerState
class_name PlayerWalkState

func enter():
	init_references()
	sprite.play("walk")

func physics_update(_delta):
	var direction = Input.get_axis("move_left", "move_right")

	_check_if_airborne_and_change_state()
	_check_if_stopped_walking_and_change_state(direction)

	_update_sprite_direction(direction)
	_apply_walk_speed(direction)
	character.move_and_slide()

func handle_input(_event):
	if Input.is_action_just_pressed("jump"):
		state_machine.change_state("jumpstate")
	if Input.is_action_just_pressed("move_down") and character.is_on_floor():
		character.position.y += 1
		state_machine.change_state("fallingstate")
	if Input.is_action_just_pressed("attack"):
		state_machine.change_state("attackingstate")

# ============================
#     SUB FUNCTIONS
# ============================

func _play_walk_animation():
	sprite.play("walk")

func _check_if_airborne_and_change_state():
	if not character.is_on_floor():
		state_machine.change_state("fallingstate")
		return

func _check_if_stopped_walking_and_change_state(direction):
	# If no horizontal input, switch to IdleState
	if direction == 0:
		state_machine.change_state("idlestate")
		return

func _update_sprite_direction(direction):
	change_direction(direction) 

func _apply_walk_speed(direction):
	character.velocity.x = direction * character.speed
