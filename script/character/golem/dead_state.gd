extends State

@export var gravity := 200.0

var landed := false

func enter():
	init_references()

	character.is_alive = false
	sprite.play("death")

	# Stop horizontal movement
	character.velocity = Vector2.ZERO

	# Disable hurtbox safely
	hurtbox.set_deferred("disabled", true)

	# Connect animation_finished signal (if not already connected)
	if not sprite.animation_finished.is_connected(_on_animation_finished):
		sprite.animation_finished.connect(_on_animation_finished)


func physics_update(delta):
	# Apply gravity every frame
	character.velocity.y += gravity * delta

	# Move the character with velocity
	character.move_and_slide()


func _on_animation_finished():
	# Disconnect to prevent multiple calls
	if sprite.animation_finished.is_connected(_on_animation_finished):
		sprite.animation_finished.disconnect(_on_animation_finished)

	# Only free if the finished animation is "death"
	if sprite.animation == "death":
		character.queue_free()
