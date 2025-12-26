extends PlayerState
class_name PlayerDamagedState
@export var knockback_strength := Vector2(50, 100)
@export var invulnerable_duration := 0.5

var is_finished := false
var blink_tween: Tween

func enter() -> void:
	init_references()
	_initialize_damaged_state()
	_apply_knockback()
	_start_invulnerability_visual()
	_play_damaged_animation()

func update(delta: float) -> void:
	_apply_gravity(delta)
	character.move_and_slide()
	
	if is_finished:
		_transition_to_next_state()

func exit() -> void:
	_cleanup_tween()
	_schedule_invulnerability_end()

func _initialize_damaged_state() -> void:
	is_finished = false
	character.is_invulnerable = true

func _apply_knockback() -> void:
	character.velocity = Vector2(
		character.hit_direction * knockback_strength.x, 
		-knockback_strength.y
	)

func _apply_gravity(delta: float) -> void:
	character.velocity.y += character.gravity * delta

func _play_damaged_animation() -> void:
	sprite.play("damaged")
	if not sprite.animation_finished.is_connected(_on_animation_finished):
		sprite.animation_finished.connect(_on_animation_finished)

func _transition_to_next_state() -> void:
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
	if is_instance_valid(character):
		sprite.modulate.a = 1.0
		character.is_invulnerable = false

func _cleanup_tween() -> void:
	if blink_tween and blink_tween.is_valid():
		blink_tween.kill()
