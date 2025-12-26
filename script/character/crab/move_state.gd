extends State

@onready var timer: Timer = $Timer

func enter():
	init_references()
	timer.start()
	sprite.play("walk")
	_randomize_direction()
	character.update_direction()

	
func physics_update(delta: float):
	# Apply gravity
	character.velocity.y += character.gravity * delta

	# Only move horizontally if not invulnerable (preserve knockback)
	if not character.is_invulnerable:
		character.velocity.x = character.speed * character.direction

	character.move_and_slide()
	_check_edges()

# --- Helpers ---
func _randomize_direction() -> void:
	character.direction = 1 if randf() > 0.5 else -1

func _check_edges() -> void:
	if character.direction < 0 and not character.raycast_left.is_colliding() and character.is_on_floor():
		character.direction = 1
	elif character.direction > 0 and not character.raycast_right.is_colliding() and character.is_on_floor():
		character.direction = -1
	character.update_direction()

func _on_timer_timeout() -> void:
	if not character.is_alive:
		return
	if randf() > 0.5:
		state_machine.change_state("idlestate")
