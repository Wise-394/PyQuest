extends State

@onready var timer: Timer = $Timer

func enter():
	init_references()
	timer.start()
	sprite.play("idle")
	
	
func physics_update(delta: float):

	character.velocity.y += character.gravity * delta
	# Preserve knockback
	if not character.is_invulnerable:
		character.velocity.x = 0

	character.move_and_slide()


func _on_timer_timeout() -> void:
	if not character.is_alive:
		return
	if randf() > 0.5:
		state_machine.change_state("movestate")
