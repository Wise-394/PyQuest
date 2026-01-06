extends State

func enter():
	init_references()
	character.is_alive = false
	character.is_invulnerable = true
	character.velocity = Vector2(0, -100)
	character.gravity = 400 
	character.health_bar.visible = false 
	
	if not sprite.animation_finished.is_connected(_on_animation_finished):
		sprite.animation_finished.connect(_on_animation_finished)
	sprite.play("dead")

func physics_update(delta: float):
	character.velocity.y += character.gravity * delta
	character.move_and_slide()

func _on_animation_finished():
	character.queue_free()
