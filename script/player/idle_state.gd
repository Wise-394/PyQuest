extends State
class_name IdleState

var character: CharacterBody2D

func enter():
	character = state_machine.player
	var player_sprite = character.player_sprite
	player_sprite.animation = "idle"
	
func physics_update(_delta: float):
	if not character.is_on_floor():
		state_machine.change_state("jumpstate")
		return
	
	character.velocity.x = 0
	character.move_and_slide()

func handle_input(_event: InputEvent):
	if Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right"):
		state_machine.change_state("walkstate")
	elif Input.is_action_just_pressed("jump"):
		state_machine.change_state("jumpstate")
	pass
