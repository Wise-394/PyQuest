extends State

@export var knockback_strength := Vector2(150, 150)
@export var invulnerable_duration := 0.5

var is_finished := false
var blink_tween: Tween

func enter() -> void:
	init_references()
	is_finished = false
	character.is_invulnerable = true

	# --- DEATH CHECK FIRST ---
	if character.current_health <= 0:
		character.is_alive = false
		state_machine.change_state("deadstate")
		return

	_apply_knockback()
	_start_invulnerability_visual()
	_play_damaged_animation()

func update(delta: float) -> void:
	# Stop all logic if dead (extra safety)
	if not character.is_alive:
		return

	_apply_gravity(delta)
	character.move_and_slide()

	if is_finished:
		_transition_to_next_state()

func exit() -> void:
	_cleanup_tween()

	if character.is_alive:
		_schedule_invulnerability_end()

func _apply_knockback() -> void:
	character.velocity = Vector2(
		character.hit_direction * knockback_strength.x,
		-knockback_strength.y
	)

func _apply_gravity(delta: float) -> void:
	character.velocity.y += character.gravity * delta

func _play_damaged_animation() -> void:
	if not sprite.animation_finished.is_connected(_on_animation_finished):
		sprite.animation_finished.connect(_on_animation_finished)
	sprite.play("damaged")

func _transition_to_next_state() -> void:
	if not character.is_alive:
		state_machine.change_state("deadstate")
		return

	var next_state := "fallingstate" if not character.is_on_floor() else "idlestate"
	state_machine.change_state(next_state)

func _on_animation_finished() -> void:
	if sprite.animation == "damaged":
		is_finished = true

func _start_invulnerability_visual() -> void:
	_cleanup_tween()
	blink_tween = create_tween()
	blink_tween.set_loops(int(invulnerable_duration * 4))
	blink_tween.tween_property(sprite, "modulate:a", 0.3, 0.15)
	blink_tween.tween_property(sprite, "modulate:a", 1.0, 0.15)

func _schedule_invulnerability_end() -> void:
	get_tree().create_timer(invulnerable_duration).timeout.connect(_end_invulnerability)

func _end_invulnerability() -> void:
	if is_instance_valid(character) and character.is_alive:
		sprite.modulate.a = 1.0
		character.is_invulnerable = false

func _cleanup_tween() -> void:
	if blink_tween and blink_tween.is_valid():
		blink_tween.kill()
