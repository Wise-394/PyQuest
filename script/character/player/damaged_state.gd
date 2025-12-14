extends State
class_name DamagedState

var is_finished := false

func enter() -> void:
	init_references()
	is_finished = false
	sprite.play("damaged")

	if not sprite.animation_finished.is_connected(_on_animation_finished):
		sprite.animation_finished.connect(_on_animation_finished)

func update(delta: float) -> void:
	character.velocity.y += character.gravity * delta
	
	if not is_finished:
		return
	if(character.is_on_floor()):
		state_machine.change_state("idlestate")
	else:
		state_machine.change_state("fallingstate")
	
func _on_animation_finished() -> void:
	if sprite.animation == "damaged":
		is_finished = true
