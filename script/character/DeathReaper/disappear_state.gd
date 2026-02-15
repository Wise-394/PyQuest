extends State

func enter():
	init_references()
	if not sprite.animation_finished.is_connected(_animation_finished):
		sprite.animation_finished.connect(_animation_finished)
	sprite.play("disappear")	

func exit():
	if sprite.animation_finished.is_connected(_animation_finished):
		sprite.animation_finished.disconnect(_animation_finished)
		
		
func _animation_finished():
	character.visible = false
	
	var rand = randf()
	
	if rand > 0.4:
		state_machine.change_state('appearstate')
	else: 
		state_machine.change_state('codestate')
