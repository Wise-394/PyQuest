extends State


@onready var timer: Timer = $Timer

func enter():
	init_references()
	if not sprite.animation_finished.is_connected(_animation_finished):
		sprite.animation_finished.connect(_animation_finished)
	sprite.play('anticipation')
	
func exit():
	if sprite.animation_finished.is_connected(_animation_finished):
		sprite.animation_finished.disconnect(_animation_finished)

func _animation_finished():
	if sprite.animation == "anticipation":
		timer.start()


func _on_timer_timeout() -> void:
	if not character.is_alive:
		return
	state_machine.change_state("attackstate")
