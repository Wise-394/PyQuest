extends State

func enter():
	init_references()
	sprite.play("walk")
	_randomize_facing_direction()
	character.update_direction()

func physics_update(_delta: float):
	character.velocity.x = character.speed * character.direction
	character.move_and_slide()
	check_edge_detection()

func _randomize_facing_direction():
	var rand = randf()
	if rand > 0.5:
		character.direction =  1
	else:
		character.direction = -1
		 
func check_edge_detection() -> void:
	if character.direction < 0:
		if not character.raycast_left.is_colliding():
			character.direction = 1
			character.update_direction()
	else:
		if not character.raycast_right.is_colliding():
			character.direction = -1
			character.update_direction()


func _on_timer_timeout() -> void:
	var rand = randf()
	if rand > 0.5:
		state_machine.change_state("idlestate")
