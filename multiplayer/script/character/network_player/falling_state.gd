extends State

var coyote_timer := 0.0
var came_from_ground := false
const MAX_FALL_SPEED := 500.0

# ───────────────────────────── lifecycle ─────────────────────────────
func enter() -> void:
	init_references()
	sprite.play("fall")

	match state_machine.previous_state:
		"idlestate", "walkstate":
			coyote_timer = character.cayote_time
			came_from_ground = true
		_:
			coyote_timer = 0.0
			came_from_ground = false

# ───────────────────────────── update ────────────────────────────────
func physics_update(delta: float) -> void:
	_update_coyote_timer(delta)
	_handle_jump_input()
	_apply_gravity(delta)
	_apply_air_movement()
	character.move_and_slide()
	_check_landing()

func handle_input(_event: InputEvent) -> void:
	pass

# ───────────────────────────── movement ──────────────────────────────
func _update_coyote_timer(delta: float) -> void:
	if coyote_timer > 0.0:
		coyote_timer -= delta

func _handle_jump_input() -> void:
	if Input.is_action_just_pressed("jump") and coyote_timer > 0.0:
		character.velocity.y = -character.jump_strength
		coyote_timer = 0.0
		state_machine.change_state("jumpstate")

func _apply_gravity(delta: float) -> void:
	character.velocity.y += character.gravity * delta

func _apply_air_movement() -> void:
	var direction := Input.get_axis("move_left", "move_right")
	if direction != 0:
		character.velocity.x = direction * character.air_speed
		character.change_direction(direction)
	else:
		character.velocity.x = lerp(character.velocity.x, 0.0, 0.2)

func _check_landing() -> void:
	if not character.is_on_floor():
		return
	var direction := Input.get_axis("move_left", "move_right")
	if direction != 0:
		state_machine.change_state("movestate")
	else:
		state_machine.change_state("idlestate")
