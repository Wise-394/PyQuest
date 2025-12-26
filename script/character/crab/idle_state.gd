extends State

func enter():
	init_references()
	sprite.play("idle")

func physics_update(_delta: float):
	character.velocity.y += character.gravity * _delta 
	character.velocity.x = 0
	character.move_and_slide()

func _on_timer_timeout() -> void:
	var rand = randf()
	if rand > 0.5:
		state_machine.change_state("movestate")
