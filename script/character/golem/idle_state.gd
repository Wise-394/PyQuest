extends State

# ===============================
# EXPORTS (Hover Parameters)
# ===============================
@export var hover_amplitude: float = 20.0   # vertical bobbing distance in pixels
@export var hover_speed: float = 2.5        # vertical bobbing speed

@export var side_amplitude: float = 12.0    # horizontal sway distance in pixels
@export var side_speed: float = 1.5         # horizontal sway speed (slower than vertical)

# ===============================
# INTERNAL STATE
# ===============================
@onready var timer: Timer = $Timer
var base_position: Vector2                  # initial position when entering state
var time_elapsed: float = 0.0               # timer for sine calculations

# ===============================
# ENTER STATE
# ===============================
func enter() -> void:
	init_references()
	timer.start()
	sprite.play("idle")

	# Save the starting position for hover calculations
	base_position = character.global_position
	time_elapsed = 0.0

# ===============================
# PHYSICS UPDATE
# ===============================
func physics_update(delta: float) -> void:
	# Face the player (centralized in enemy script)
	character.face_player()

	# Increment timer
	time_elapsed += delta

	# Compute hover offsets using sine waves
	var vertical_offset = sin(time_elapsed * hover_speed) * hover_amplitude
	var horizontal_offset = sin(time_elapsed * side_speed) * side_amplitude

	# Compute target position based on offsets
	var target_position = base_position + Vector2(horizontal_offset, vertical_offset)

	# Convert target position to velocity for CharacterBody2D movement
	character.velocity = (target_position - character.global_position) / delta
	character.move_and_slide()

func exit():
	timer.stop()
	
func _on_timer_timeout() -> void:
	state_machine.change_state("movestate")
