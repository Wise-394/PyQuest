extends State

# --- Exports ---
@export var invulnerability_duration := 0.5
@export var knockback_strength := 100
@export var knockback_upward := 200

# --- State callbacks ---
func enter():
	init_references()
	_start_invulnerability()
	_apply_knockback()

	# Connect animation finished signal once
	if not sprite.animation_finished.is_connected(_on_animation_finished):
		sprite.animation_finished.connect(_on_animation_finished)

	sprite.play("damaged")

func exit():
	_end_invulnerability()

func physics_update(delta: float):
	# Apply gravity
	character.velocity.y += character.gravity * delta
	character.move_and_slide()

# --- Knockback ---
func _apply_knockback():
	character.velocity.x = knockback_strength * character.hit_direction
	character.velocity.y = -knockback_upward

# --- Helpers ---
func _start_invulnerability():
	character.can_change_direction = false
	character.is_invulnerable = true

func _end_invulnerability():
	character.can_change_direction = true
	character.is_invulnerable = false

# --- Animation finished handler ---
func _on_animation_finished() -> void:
	if sprite.animation != "damaged":
		return

	if not character.is_alive:
		state_machine.change_state("deadstate")
	elif character.is_on_floor():
		state_machine.change_state("movestate")
