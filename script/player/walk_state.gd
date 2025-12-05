extends State
class_name WalkState

var character: CharacterBody2D

func enter():
	character = state_machine.player
	var player_sprite = character.player_sprite
	
	player_sprite.animation = "walk"
	
func physics_update(_delta: float):
	var direction = Input.get_axis("move_left", "move_right")
	if not character.is_on_floor():
		state_machine.change_state("jumpstate")
		return
	if direction == 0:
		state_machine.change_state("idlestate")
		return

	character.velocity.x = direction * character.speed
	character.move_and_slide()
	

func handle_input(_event: InputEvent):
	if Input.is_action_just_pressed("jump"):
		state_machine.change_state("jumpstate")
