extends State

@onready  var timer: Timer = $Timer
func enter():
	init_references()
	timer.start()
	sprite.play("idle")


func _on_timer_timeout() -> void:
	var rand_num = randf()
	if rand_num > 0.4:
		state_machine.change_state('walkstate')
	else:
		state_machine.change_state('backawaystate')
