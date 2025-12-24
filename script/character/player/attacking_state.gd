extends State
class_name AttackingState

func enter():
	init_references()
	hitbox.monitoring = false
	if not sprite.animation_finished.is_connected(_finished_attacking):
		sprite.animation_finished.connect(_finished_attacking)	
	sprite.play("attacking")

func exit():
	hitbox.monitoring = false
	
func _finished_attacking():
	if sprite.animation == "attacking":
		_check_floor_state()

func _check_floor_state():
	if not character.is_on_floor():
		state_machine.change_state("fallingstate")
	else:
		state_machine.change_state("idlestate")

	
