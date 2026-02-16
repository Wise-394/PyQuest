extends State


func enter():
	init_references()
	hitbox.monitoring = false
	character.is_alive = false
	if not sprite.animation_finished.is_connected(_animation_finished):
		sprite.animation_finished.connect(_animation_finished)
	sprite.play("disappear")	

func exit():
	if sprite.animation_finished.is_connected(_animation_finished):
		sprite.animation_finished.disconnect(_animation_finished)
		


func _animation_finished():
	if sprite.animation == 'disappear':
		character.finished.emit()
		character.queue_free()
