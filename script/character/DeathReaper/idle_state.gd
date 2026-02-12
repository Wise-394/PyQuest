extends State

@onready  var timer: Timer = $Timer
func enter():
	init_references()
	timer.start()
	sprite.play("idle")


func _on_timer_timeout() -> void:
	state_machine.change_state('walkstate')
