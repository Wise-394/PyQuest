extends State

# --- Configuration ---
@export var hop_interval: float = 1             # Base time between hops
@export var hop_force: float = -260.0           # Vertical jump impulse
@export var move_speed: float = 80.0            # Horizontal speed per hop
@export var max_chase_distance: int = 250       # Max horizontal distance to chase
@export var max_vertical_distance: int = 150    # Max vertical distance to chase
@export var horizontal_tolerance: int = 6       # Minimal x-distance to adjust direction

# --- State variables ---
var hop_timer := 0.0

# --- Lifecycle ---
func enter():
	init_references()
	hop_timer = 0.0
	_play_animation("idle")

func physics_update(delta: float):
	if not _can_act():
		return

	_apply_gravity(delta)
	hop_timer -= delta

	if _should_de_aggro():
		_de_aggro()
		return

	_face_player()

	# Only hop when on the floor AND timer expired
	if character.is_on_floor() and hop_timer <= 0:
		_do_hop()
	else:
		# Stop horizontal movement while waiting on floor
		if character.is_on_floor():
			character.velocity.x = 0
			_play_animation("idle")

	_move_and_slide()

# --- Hop Logic ---
func _do_hop():
	# Reset timer BEFORE jumping to prevent immediate repeated hops
	hop_timer = hop_interval + randf_range(-0.1, 0.15)

	# Calculate horizontal direction
	var x_diff = character.player.global_position.x - character.global_position.x

	if abs(x_diff) > horizontal_tolerance:
		_set_direction(sign(x_diff))
		character.velocity.x = move_speed * character.direction
	else:
		character.velocity.x = 0

	# Apply vertical impulse
	character.velocity.y = hop_force

	_play_animation("jump")

# --- Facing ---
func _face_player():
	var x_diff = character.player.global_position.x - character.global_position.x
	if abs(x_diff) > 1:
		_set_direction(sign(x_diff))

# --- De-Aggro ---
func _should_de_aggro() -> bool:
	if character.player == null:
		return true

	var h = abs(character.player.global_position.x - character.global_position.x)
	var v = abs(character.player.global_position.y - character.global_position.y)

	return h > max_chase_distance or v > max_vertical_distance

func _de_aggro():
	character.velocity = Vector2.ZERO
	character.player = null
 	#character.health_bar.visible = false
	character.state_machine.change_state("idlestate")

# --- Utility ---
func _can_act() -> bool:
	return character.is_alive and character.player != null

func _apply_gravity(delta: float):
	character.velocity.y += character.gravity * delta

func _set_direction(new_dir: int):
	if character.direction != new_dir:
		character.direction = new_dir
		character.update_direction()

func _play_animation(anim_name: String):
	if sprite.animation != anim_name:
		sprite.play(anim_name)

func _move_and_slide():
	character.move_and_slide()
