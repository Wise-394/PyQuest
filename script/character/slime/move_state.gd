extends State
class_name PatrolState

# -----------------------------
# Configuration
# -----------------------------
@export var idle_chance: float = 0.5
@export var flip_direction_chance: float = 0.5

# -----------------------------
# Node References
# -----------------------------
@onready var timer: Timer = $Timer

# -----------------------------
# State Lifecycle
# -----------------------------
func enter() -> void:
	init_references()
	_start_patrol()

func exit() -> void:
	_stop_patrol()

func physics_update(delta: float) -> void:
	_apply_gravity(delta)
	_apply_horizontal_movement(delta)
	_move()
	_handle_edges()
	if not character.player == null:
		state_machine.change_state("aggrostate")

# -----------------------------
# Patrol Control
# -----------------------------
func _start_patrol() -> void:
	timer.start()
	sprite.play("walk")
	_set_random_direction()

func _stop_patrol() -> void:
	timer.stop()

# -----------------------------
# Movement
# -----------------------------
func _apply_gravity(delta: float) -> void:
	character.velocity.y += character.gravity * delta

func _apply_horizontal_movement(delta: float) -> void:
	if character.is_invulnerable:
		return

	var target_speed: float = float(character.speed) * float(character.target_direction)
	character.velocity.x = lerp(
		character.velocity.x,
		target_speed,
		character.turn_speed * delta
	)


func _move() -> void:
	character.move_and_slide()

# -----------------------------
# Edge Detection
# -----------------------------
func _handle_edges() -> void:
	if not character.is_on_floor():
		return

	if _should_turn_left():
		character.request_direction(1)
	elif _should_turn_right():
		character.request_direction(-1)

func _should_turn_left() -> bool:
	return character.direction < 0 and not character.raycast_left.is_colliding()

func _should_turn_right() -> bool:
	return character.direction > 0 and not character.raycast_right.is_colliding()

# -----------------------------
# Direction Helpers
# -----------------------------
func _set_random_direction() -> void:
	var new_direction := 1 if randf() > 0.5 else -1
	character.request_direction(new_direction)


# -----------------------------
# Timer Callback
# -----------------------------
func _on_timer_timeout() -> void:
	if not character.is_alive:
		return

	if _should_go_idle():
		state_machine.change_state("idlestate")
	else:
		_try_flip_direction()

func _should_go_idle() -> bool:
	return randf() < idle_chance

func _try_flip_direction() -> void:
	if randf() < flip_direction_chance:
		character.request_direction(-character.direction)
