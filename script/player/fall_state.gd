# FallState.gd
extends State
class_name FallState

@export var gravity: float = 1000.0
@export var air_speed: float

func physics_update(delta: float):
	var character = state_machine.get_parent()

	# Apply gravity continuously
	character.velocity.y += gravity * delta

	# Handle horizontal air movement
	var direction = Input.get_axis("move_left", "move_right")
	character.velocity.x = direction * air_speed
	character.move_and_slide()

	# Check for landing and transition back to ground states
	if character.is_on_floor():
		if direction != 0:
			state_machine.change_state("walkstate")
		else:
			state_machine.change_state("idlestate")
