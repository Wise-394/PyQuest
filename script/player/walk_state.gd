# WalkState handles the player's walking behavior.


extends State
class_name WalkState

var character: CharacterBody2D       
var sprite: AnimatedSprite2D      

func enter():
	character = state_machine.player
	sprite = character.player_sprite
	sprite.animation = "walk"       

func physics_update(_delta):
	# Get horizontal input: -1 for left, 1 for right, 0 for no input
	var direction = Input.get_axis("move_left", "move_right")

	# If player is in the air, switch to JumpState
	if not character.is_on_floor():
		state_machine.change_state("jumpstate")
		return

	# If no horizontal input, switch to IdleState
	if direction == 0:
		state_machine.change_state("idlestate")
		return

	change_direction(direction, sprite)  # Update sprite orientation based on movement direction


	character.velocity.x = direction * character.speed
	character.move_and_slide()

func handle_input(_event):
	if Input.is_action_just_pressed("jump"):
		state_machine.change_state("jumpstate")
