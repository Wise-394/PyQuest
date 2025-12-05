# JumpState handles the player's jumping behavior.
# Applies gravity, allows horizontal movement in the air,
extends State
class_name JumpState

var character: CharacterBody2D       
var sprite: AnimatedSprite2D    

func enter():
	character = state_machine.player
	sprite = character.player_sprite

	# If entering JumpState from the ground (jumping)
	if Input.is_action_just_pressed("jump") and character.is_on_floor():
		character.velocity.y = -character.jump_strength

	sprite.play("jump")
	

func physics_update(delta):
	# Apply gravity
	character.velocity.y += character.gravity * delta

	var direction = Input.get_axis("move_left", "move_right")

	if direction != 0:
		# Move player horizontally in the air
		character.velocity.x = direction * character.speed
		sprite.flip_h = direction < 0   # Flip sprite based on movement direction
	else:
		character.velocity.x = lerp(character.velocity.x, 0.0, 0.2)

	character.move_and_slide() 

	
	if character.is_on_floor():
		if direction != 0:
			state_machine.change_state("walkstate")
		else:
			state_machine.change_state("idlestate") 
