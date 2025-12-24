extends State
class_name FallingState
var coyote_timer := 0.0      
var came_from_ground := false
var max_fall_speed := 500.0  # Add a cap for fall speed

func enter():
	init_references()
	sprite.play("fall")
	
	# Cap vertical velocity if coming from damaged state
	var previous_state = state_machine.previous_state
	if previous_state == "damagedstate":
		character.velocity.y = clamp(character.velocity.y, -character.jump_strength, max_fall_speed)
		coyote_timer = 0.0
		came_from_ground = false
	elif previous_state in ["idlestate", "walkstate"]:
		coyote_timer = character.cayote_time
		came_from_ground = true
	else:
		coyote_timer = 0.0
		came_from_ground = false
		
func update(_delta: float):
	_handle_attack()
	
func physics_update(delta):
	_update_coyote_timer(delta)
	_handle_jump_input()
	_apply_gravity(delta)
	_apply_air_movement()
	character.move_and_slide()
	_check_landing()

func _update_coyote_timer(delta):
	if coyote_timer > 0.0:
		coyote_timer -= delta

func _handle_attack():
	if Input.is_action_just_pressed("attack"):
		state_machine.change_state("jumpattackingstate")

func _handle_jump_input():
	if Input.is_action_just_pressed("jump") and coyote_timer > 0.0:
		character.velocity.y = -character.jump_strength
		coyote_timer = 0.0
		sprite.play("jump")
		state_machine.change_state("JumpState")

func _apply_gravity(delta):
	character.velocity.y += character.gravity * delta
	character.velocity.y = min(character.velocity.y, max_fall_speed)  # Cap fall speed

func _apply_air_movement():
	var direction = Input.get_axis("move_left", "move_right")
	if direction != 0:
		character.velocity.x = direction * character.speed
		change_direction(direction)  # Use parent function
	else:
		character.velocity.x = lerp(character.velocity.x, 0.0, 0.2)

func _check_landing():
	var direction = Input.get_axis("move_left", "move_right")
	if character.is_on_floor():
		if direction != 0:
			state_machine.change_state("WalkState")
		else:
			state_machine.change_state("IdleState")
