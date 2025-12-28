extends State

# --- Configuration ---
@export var horizontal_tolerance: int = 8
@export var attack_range: int = 42
@export var attack_cooldown: float = 1.0
@export var max_chase_distance: int = 250
@export var max_vertical_distance: int = 150

# --- State variables ---
var attack_cooldown_timer := 0.0

# --- Lifecycle ---
func enter():
	init_references()

func physics_update(delta: float):
	if not _can_act():
		return
	
	_apply_gravity(delta)
	attack_cooldown_timer = max(0, attack_cooldown_timer - delta)

	if _should_de_aggro():
		_de_aggro()
		return

	if _try_attack():
		return

	_chase_player()

	# Edge check
	if _is_at_edge():
		_de_aggro()
		return

	_move_and_slide()

# --- De-Aggro Logic ---
func _should_de_aggro() -> bool:
	if character.player == null:
		return true

	var horizontal_distance = abs(character.player.global_position.x - character.global_position.x)
	var vertical_distance = abs(character.player.global_position.y - character.global_position.y)

	return horizontal_distance > max_chase_distance \
		or vertical_distance > max_vertical_distance \
		or _is_at_edge()

func _is_at_edge() -> bool:
	if not character.is_on_floor():
		return false

	if character.direction < 0 and not character.raycast_left.is_colliding():
		return true

	if character.direction > 0 and not character.raycast_right.is_colliding():
		return true

	return false

func _de_aggro():
	character.velocity.x = 0
	_stop_moving()
	character.player = null
	character.health_bar.visible = false
	character.state_machine.change_state("idlestate")

# --- Attack Logic ---
func _try_attack() -> bool:
	if attack_cooldown_timer > 0:
		return false

	var distance = character.global_position.distance_to(character.player.global_position)
	if distance <= attack_range:
		attack_cooldown_timer = attack_cooldown
		character.state_machine.change_state("anticipationstate")
		return true

	return false

# --- Chase Logic ---
func _chase_player():
	var x_diff = character.player.global_position.x - character.global_position.x

	if abs(x_diff) > horizontal_tolerance:
		_move_towards_player(x_diff)
	else:
		_stop_moving()

func _move_towards_player(x_diff: float):
	_set_direction(sign(x_diff))
	character.velocity.x = character.speed * character.direction
	_play_animation("walk")

func _stop_moving():
	character.velocity.x = 0
	_play_animation("idle")

# --- Movement ---
func _move_and_slide():
	character.move_and_slide()

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
