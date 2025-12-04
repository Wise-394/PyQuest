#manages state when "not on ground"
#falling(applying gravity)/jumping are both managed in this state
extends State
class_name JumpState

func enter():
	var character = state_machine.player 
	if Input.is_action_just_pressed("jump"):
		character.velocity.y = -character.jump_strength

func physics_update(delta: float):
	var character = state_machine.player
	character.velocity.y += character.gravity * delta

	var direction = Input.get_axis("move_left", "move_right")
	character.velocity.x = direction * character.air_speed
	
	character.move_and_slide()
	if character.is_on_floor():
		if direction != 0:
			state_machine.change_state("walkstate")
		else:
			state_machine.change_state("idlestate")
