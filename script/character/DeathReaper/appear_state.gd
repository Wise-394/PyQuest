extends State

var x = [130, 440]
var y = -11

func enter():
	init_references()
	if not sprite.animation_finished.is_connected(_animation_finished):
		sprite.animation_finished.connect(_animation_finished)
	
	character.visible = true
	character.global_position = Vector2(randf_range(x[0], x[1]), y)
	update_direction()
	sprite.play('appear')

func exit():
	if sprite.animation_finished.is_connected(_animation_finished):
		sprite.animation_finished.disconnect(_animation_finished)

func update_direction():
	if character.player.global_position.x > character.global_position.x:
		character.direction = 1
		character.pivot.scale.x = -1.3
	else:
		character.direction = -1
		character.pivot.scale.x = 1.3

func _animation_finished():
	hitbox.monitoring = true
	state_machine.change_state("idlestate")
