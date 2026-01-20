extends State

@export var gravity := 200.0

func enter():
	init_references()

	sprite.offset.y = -21
	character.is_alive = false
	sprite.play("death")

	# Stop movement
	character.velocity = Vector2.ZERO

	# COLLISION SETUP
	character.set_deferred("collision_layer", 0) # not detected by anything
	character.set_deferred("collision_mask", 2)  # only collide with ground

	# Disable hurtbox safely (if used)
	# hurtbox.set_deferred("disabled", true)

	# Signal
	if not sprite.animation_finished.is_connected(_on_animation_finished):
		sprite.animation_finished.connect(_on_animation_finished)


func physics_update(delta):
	character.velocity.y += gravity * delta
	character.move_and_slide()


func _on_animation_finished():
	if sprite.animation_finished.is_connected(_on_animation_finished):
		sprite.animation_finished.disconnect(_on_animation_finished)

	if sprite.animation == "death":
		character.finished.emit()
		# character.queue_free()
