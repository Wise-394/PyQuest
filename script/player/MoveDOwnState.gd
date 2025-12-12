extends State
class_name MoveDownState

const DROP_DISTANCE := 1
const SPEED := 300

func enter():
	init_references()
	sprite.play("jump")
	character.position.y += DROP_DISTANCE

func physics_update(delta):
	character.velocity.y += character.gravity * delta
	var direction = Input.get_axis("move_left", "move_right") 
	character.velocity.x = direction * SPEED

	character.move_and_slide()

	if character.is_on_floor():
		state_machine.change_state("idlestate")
