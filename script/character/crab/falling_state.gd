extends State

func enter():
	init_references()
	sprite.play("fall") 

func physics_update(delta: float) -> void:
	character.velocity.y += character.gravity * delta
	character.move_and_slide()

	if character.is_on_floor():
		state_machine.change_state("idle")
