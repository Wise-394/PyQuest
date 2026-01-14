extends State

@export var speed := 100.0          
@export var stop_distance := 70    
@export var vertical_offset := 30.0 

var player = null

func enter():
	init_references()
	player = character.player 

func physics_update(_delta):
	if not player:
		return

	# Target position slightly above the player
	var target_position = player.global_position + Vector2(0, -vertical_offset)
	
	# Direction vector from golem to target position
	var direction = (target_position - character.global_position).normalized()
	
	# Set velocity toward target
	character.velocity = direction * speed
	
	# Move the character using velocity
	character.move_and_slide()
	
	# Check distance to target position
	var distance = character.global_position.distance_to(target_position)
	if distance <= stop_distance:
		# Stop movement
		character.velocity = Vector2.ZERO
		# Transition to next state
		character.state_machine.change_state("MeleeAttackState")
