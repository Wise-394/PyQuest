# JumpState handles the player's jumping behavior.
# Applies gravity, allows horizontal movement in the air,
extends State
class_name JumpState

# --- Coyote time - grace period that allows player to jump even not on floor ---
var coyote_timer := 0.0

func enter():
	init_references()
	_handle_initial_jump_or_fall()
	sprite.play("jump")


func physics_update(delta):
	_update_coyote_time(delta)
	_try_coyote_jump()
	_apply_gravity(delta)
	_apply_air_movement()
	character.move_and_slide()
	_check_landing_and_change_state()


# ============================
#     SUB FUNCTIONS
# ============================
func _handle_initial_jump_or_fall():
	# If entering JumpState from the ground (jumping)
	if Input.is_action_just_pressed("jump") and character.is_on_floor():
		character.velocity.y = -character.jump_strength
		coyote_timer = 0.0   # consume grace since you jumped
	else:
		# If we enter jump state because we walked off a ledge
		coyote_timer = coyote_time


func _update_coyote_time(delta):
	if not character.is_on_floor():
		coyote_timer -= delta
	else:
		coyote_timer = 0.0   # if grounded again, no more coyote time


func _try_coyote_jump():
	# --- Allow jump during coyote time ---
	if Input.is_action_just_pressed("jump") and coyote_timer > 0.0:
		character.velocity.y = -character.jump_strength
		coyote_timer = 0.0   # consume grace period
		sprite.play("jump")


func _apply_gravity(delta):
	character.velocity.y += character.gravity * delta


func _apply_air_movement():
	var direction = Input.get_axis("move_left", "move_right")

	if direction != 0:
		# Move player horizontally in the air
		character.velocity.x = direction * character.speed
		sprite.flip_h = direction < 0
	else:
		character.velocity.x = lerp(character.velocity.x, 0.0, 0.2)


func _check_landing_and_change_state():
	var direction = Input.get_axis("move_left", "move_right")

	if character.is_on_floor():
		if direction != 0:
			state_machine.change_state("walkstate")
		else:
			state_machine.change_state("idlestate")
