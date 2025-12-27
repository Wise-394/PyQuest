extends State

func enter():
	init_references()
	if not sprite.animation_finished.is_connected(_on_animation_finished):
		sprite.animation_finished.connect(_on_animation_finished)
	sprite.play("anticipation")

func exit():
	if sprite.animation_finished.is_connected(_on_animation_finished):
		sprite.animation_finished.disconnect(_on_animation_finished)

func _on_animation_finished():
	if sprite.animation == "anticipation":
		character.state_machine.change_state("attackstate")
