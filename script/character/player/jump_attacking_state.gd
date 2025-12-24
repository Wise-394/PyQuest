extends State
class_name JumpAttackingState

func enter():
	init_references()
	hitbox.monitoring = true
	if not sprite.animation_finished.is_connected(_finished_attacking):
		sprite.animation_finished.connect(_finished_attacking)	
	sprite.play("jump_attacking")

func exit():
	hitbox.monitoring = false
	
func physics_update(_delta: float):
	_apply_gravity(_delta)
	character.move_and_slide()  
	
func _finished_attacking():
	if sprite.animation == "jump_attacking":
		_check_floor_state()

func _check_floor_state():
	if not character.is_on_floor():
		state_machine.change_state("fallingstate")
	else:
		state_machine.change_state("idlestate")
	
func _apply_gravity(delta):
	character.velocity.y += character.gravity * delta
