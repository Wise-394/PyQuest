extends State

@onready  var timer: Timer = $Timer
func enter():
	init_references()
	timer.start()
	sprite.play("idle")


func _on_timer_timeout() -> void:
	var roll: float = randf()
	var result: String

	if roll < 0.50:
		result = "WALK"
	elif roll < 0.75:
		result = "CAST"
	else:
		result = "DISAPPEAR"

	match result:
		"WALK":
			state_machine.change_state("walkstate")
		"CAST":
			state_machine.change_state("backawaystate")
		"DISAPPEAR":
			state_machine.change_state("disappearstate")
