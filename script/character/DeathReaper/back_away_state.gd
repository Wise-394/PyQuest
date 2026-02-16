extends State

@onready var timer:Timer = $Timer
func enter():
	init_references()
	sprite.play('walk')
	timer.start()


func update(_delta: float):
		character.velocity.x = character.direction * (character.speed * 1.3) * -1
		update_direction()
		character.move_and_slide()

func update_direction():
	if character.player.global_position.x > character.global_position.x:
		character.direction = 1
		character.pivot.scale.x = -1.3
	else:
		character.direction = -1
		character.pivot.scale.x = 1.3


func _on_timer_timeout() -> void:
	if not character.is_alive:
		return
	state_machine.change_state('caststate')
