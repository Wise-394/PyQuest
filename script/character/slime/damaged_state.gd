extends State

# --- Exports ---
@export var invulnerability_duration := 0.5
@export var knockback_strength := 150
@export var knockback_upward := 250
@export var knockback_friction := 300  # Add friction to slow down knockback
@export var blink_duration := 0.2  # How long each blink lasts (increased from 0.1)
@export var blink_count := 2  # Number of blinks (reduced from 3)

var damage_tween: Tween

# --- State callbacks ---
func enter():
	init_references()
	_start_invulnerability()
	_apply_knockback()
	_start_damage_blink()
	
	# Connect animation finished signal once
	if not sprite.animation_finished.is_connected(_on_animation_finished):
		sprite.animation_finished.connect(_on_animation_finished)
	
	sprite.play("damaged")

func exit():
	_end_invulnerability()
	_stop_damage_blink()

func physics_update(delta: float):
	# Apply gravity
	character.velocity.y += character.gravity * delta
	
	# Apply friction to horizontal knockback
	if character.is_on_floor():
		character.velocity.x = move_toward(character.velocity.x, 0, knockback_friction * delta)
	else:
		# Less friction in air
		character.velocity.x = move_toward(character.velocity.x, 0, knockback_friction * 0.5 * delta)
	
	character.move_and_slide()

# --- Knockback ---
func _apply_knockback():
	character.velocity.x = knockback_strength * character.hit_direction
	character.velocity.y = -knockback_upward

# --- Damage Visual Effect ---
func _start_damage_blink():
	# Kill existing tween if any
	if damage_tween:
		damage_tween.kill()
	
	damage_tween = create_tween()
	damage_tween.set_loops(blink_count)
	
	# Tween to white (modulate = white makes sprite white)
	damage_tween.tween_property(sprite, "modulate", Color(10, 10, 10, 1), blink_duration * 0.5)
	# Tween back to normal
	damage_tween.tween_property(sprite, "modulate", Color(1, 1, 1, 1), blink_duration * 0.5)

func _stop_damage_blink():
	if damage_tween:
		damage_tween.kill()
	# Ensure sprite returns to normal color
	sprite.modulate = Color(1, 1, 1, 1)

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
		state_machine.change_state("aggrostate")
