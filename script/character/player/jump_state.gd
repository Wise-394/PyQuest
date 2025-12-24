extends State
class_name JumpState
# ============================
#        ENTER STATE
# ============================
func enter():
	init_references()
	_handle_initial_jump()
	sprite.play("jump")

func update(_delta: float):
	_handle_attack()

# ============================
#      PHYSICS UPDATE
# ============================
func physics_update(delta):
	_apply_gravity(delta)
	_apply_air_movement()
	character.move_and_slide()
	_check_if_falling()

# ============================
#       SUB FUNCTIONS
# ============================
func _handle_initial_jump():
	if Input.is_action_just_pressed("jump") and character.is_on_floor():
		character.velocity.y = -character.jump_strength

func _handle_attack():
	if Input.is_action_just_pressed("attack"):
		state_machine.change_state("jumpattackingstate")

func _apply_gravity(delta):
	character.velocity.y += character.gravity * delta

func _apply_air_movement():
	var direction = Input.get_axis("move_left", "move_right")
	if direction != 0:
		character.velocity.x = direction * character.speed
		change_direction(direction) 
	else:
		character.velocity.x = lerp(character.velocity.x, 0.0, 0.2)

func _check_if_falling():
	if character.velocity.y > 0:
		state_machine.change_state("fallingstate")
