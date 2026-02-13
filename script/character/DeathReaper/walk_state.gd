extends State


@export var player_minimum_range = 100
func enter():
	init_references()
	sprite.play('walk')


func update(_delta: float):
	if not is_player_near():
		character.velocity.x = character.direction * character.speed
		update_direction()
		character.move_and_slide()
	else:
		state_machine.change_state("anticipationstate")

func update_direction():
	if character.player.global_position.x > character.global_position.x:
		character.direction = 1
		character.pivot.scale.x = -1.3
	else:
		character.direction = -1
		character.pivot.scale.x = 1.3

func is_player_near() -> bool:
	if not character.player:
		return false
	
	var distance = character.global_position.distance_to(character.player.global_position)
	return distance <= player_minimum_range
