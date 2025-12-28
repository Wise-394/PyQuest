extends State

@onready var timer: Timer = $Timer

func enter():
	init_references()
	timer.start()
	sprite.play("walk")
	_set_random_direction()

func exit():
	timer.stop()

func physics_update(delta: float):
	# Apply gravity
	character.velocity.y += character.gravity * delta

	# Only move horizontally if not invulnerable (preserve knockback)
	if not character.is_invulnerable:
		character.velocity.x = character.speed * character.direction

	character.move_and_slide()
	_check_edges()
	if not character.player == null:
		state_machine.change_state("aggrostate")
# --- Helpers ---

func _set_random_direction() -> void:
	var new_dir := 1 if randf() > 0.5 else -1
	_set_direction(new_dir)

func _set_direction(new_dir: int) -> void:
	if character.direction == new_dir:
		return
	character.direction = new_dir
	character.update_direction()

func _check_edges() -> void:
	if not character.is_on_floor():
		return

	if character.direction < 0 and not character.raycast_left.is_colliding():
		_set_direction(1)
	elif character.direction > 0 and not character.raycast_right.is_colliding():
		_set_direction(-1)

func _on_timer_timeout() -> void:
	if not character.is_alive:
		return

	if randf() > 0.5:
		state_machine.change_state("idlestate")
