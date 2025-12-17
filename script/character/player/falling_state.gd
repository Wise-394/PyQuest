extends State
class_name FallingState

# -----------------------------
#        VARIABLES
# -----------------------------
var coyote_timer := 0.0      
var came_from_ground := false

# -----------------------------
#        ENTER STATE
# -----------------------------
func enter():
	init_references()
	sprite.play("fall")
	
	# Only grant coyote time if coming from a grounded state
	var previous_state = state_machine.previous_state
	if previous_state in ["idlestate", "walkstate"]:
		coyote_timer = character.cayote_time
		came_from_ground = true
	else:
		coyote_timer = 0.0
		came_from_ground = false

# -----------------------------
#      PHYSICS UPDATE
# -----------------------------
func physics_update(delta):
	_update_coyote_timer(delta)  # Update coyote timer each frame
	_handle_jump_input()         # Check for jump input and perform coyote jump
	_apply_gravity(delta)        # Apply gravity to vertical velocity
	_apply_air_movement()        # Apply horizontal movement while in air
	character.move_and_slide()    # Move the character using current velocity
	_check_landing()             # Check if character landed to change state

# -----------------------------
#       INTERNAL FUNCTIONS
# -----------------------------
func _update_coyote_timer(delta):
	# Reduce coyote timer over time
	if coyote_timer > 0.0:
		coyote_timer -= delta

func _handle_jump_input():
	if Input.is_action_just_pressed("jump") and coyote_timer > 0.0:
		character.velocity.y = -character.jump_strength
		coyote_timer = 0.0
		sprite.play("jump")
		state_machine.change_state("JumpState")
func handle_fall_faster():
	if Input.is_action_just_pressed("move_down"):
		character.gravity = character.gravity * 2
func _apply_gravity(delta):
	character.velocity.y += character.gravity * delta

func _apply_air_movement():
	var direction = Input.get_axis("move_left", "move_right")
	if direction != 0:
		character.velocity.x = direction * character.speed
		sprite.flip_h = direction < 0
	else:
		character.velocity.x = lerp(character.velocity.x, 0.0, 0.2)

func _check_landing():
	var direction = Input.get_axis("move_left", "move_right")
	if character.is_on_floor():
		if direction != 0:
			state_machine.change_state("WalkState")
		else:
			state_machine.change_state("IdleState")
