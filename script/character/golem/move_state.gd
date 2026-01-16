extends State

# =============================
#        ARRIVAL TYPES
# =============================
enum ArrivalType {
	LEFT,
	CENTER,
	RIGHT,
	PLAYER
}

# =============================
#        STATIC TARGETS
# =============================
const STATIC_TARGETS: Array[Vector2] = [
	Vector2(60, 160),    # LEFT
	Vector2(460, 57),    # CENTER
	Vector2(820, 160)    # RIGHT
]

# =============================
#        CONFIGURATION
# =============================
@export var move_speed := 180.0
@export var arrival_threshold := 5.0

@export_group("Player Offset")
@export var min_horizontal_offset := 100.0
@export var max_horizontal_offset := 100.0
@export var min_vertical_offset := 10.0
@export var max_vertical_offset := 40.0

@export_group("Bobbing")
@export var bobbing_amplitude := 20.0
@export var bobbing_frequency := 2.5

@export_group("Descent")
@export var descent_speed_multiplier := 0.5
@export var pause_before_descent := 0.2

# =============================
#        STATE DATA
# =============================
var target_position: Vector2
var arrival_type: ArrivalType

var has_arrived := false
var bobbing_time := 0.0

var movement_phase := 0
var intermediate_y := 57.0
var pause_timer := 0.0

# =============================
#        STATE LIFECYCLE
# =============================
func enter() -> void:
	init_references()
	sprite.play("move")
	_reset_state()
	_pick_target()

func physics_update(delta: float) -> void:
	if has_arrived:
		_stop()
		return

	character.face_player()
	_move_towards_target_stepwise(delta)

# =============================
#        TARGET LOGIC
# =============================
func _pick_target() -> void:
	var player_target := _get_player_offset_target()
	if randf() < 0.4:
		target_position = player_target
		arrival_type = ArrivalType.PLAYER
	else:
		if randf() < 0.4:
			target_position = STATIC_TARGETS[1]  # CENTER
			arrival_type = ArrivalType.CENTER
		else:
			var side_targets := [STATIC_TARGETS[0], STATIC_TARGETS[2]]
			target_position = side_targets.pick_random()
			arrival_type = _get_static_arrival_type(target_position)


func _get_player_offset_target() -> Vector2:
	var offset_x := _random_signed(min_horizontal_offset, max_horizontal_offset)
	var offset_y := -randf_range(min_vertical_offset, max_vertical_offset)
	return character.player.global_position + Vector2(offset_x, offset_y)

func _get_static_arrival_type(pos: Vector2) -> ArrivalType:
	match STATIC_TARGETS.find(pos):
		0: return ArrivalType.LEFT
		1: return ArrivalType.CENTER
		2: return ArrivalType.RIGHT
		_: return ArrivalType.CENTER

func _random_signed(min_value: float, max_value: float) -> float:
	var value := randf_range(min_value, max_value)
	return value if randf() > 0.7 else -value

# =============================
#        MOVEMENT
# =============================
func _move_towards_target_stepwise(delta: float) -> void:
	bobbing_time += delta
	var bobbing_offset := sin(bobbing_time * bobbing_frequency) * bobbing_amplitude

	var velocity := Vector2.ZERO

	match movement_phase:
		0:
			# Step 0 → Move vertically to intermediate Y
			var dy := intermediate_y - character.global_position.y
			if abs(dy) <= arrival_threshold:
				character.global_position.y = intermediate_y
				movement_phase = 1
			else:
				velocity.y = sign(dy) * move_speed

		1:
			# Step 1 → Move horizontally toward target X
			var dx := target_position.x - character.global_position.x
			if abs(dx) <= arrival_threshold:
				character.global_position.x = target_position.x
				movement_phase = 2
				pause_timer = 0.0
			else:
				velocity.x = sign(dx) * move_speed

		2:
			# Step 2 → Descent
			if pause_timer < pause_before_descent:
				pause_timer += delta
			else:
				if arrival_type == ArrivalType.PLAYER:
					# Move horizontally away from player first
					var player_pos = character.player.global_position
					var horizontal_distance = abs(character.global_position.x - player_pos.x)
					var safe_distance := max_horizontal_offset * 1.5

					if horizontal_distance < safe_distance:
						# Move horizontally away only
						velocity.x = (move_speed * 0.5) * sign(character.global_position.x - player_pos.x)
						velocity.y = 0
					else:
						# Safe → descend straight down
						var dy := target_position.y - character.global_position.y
						if abs(dy) <= arrival_threshold:
							character.global_position.y = target_position.y
							_on_arrival()
						else:
							velocity.y = sign(dy) * move_speed * descent_speed_multiplier
				else:
					# Normal descent for static targets
					var dy := target_position.y - character.global_position.y
					if abs(dy) <= arrival_threshold:
						character.global_position.y = target_position.y
						_on_arrival()
					else:
						velocity.y = sign(dy) * move_speed * descent_speed_multiplier

	# Apply bobbing offset
	velocity.y += bobbing_offset
	character.velocity = velocity
	character.move_and_slide()

# =============================
#        ARRIVAL → STATE CHOICE
# =============================
func _on_arrival() -> void:
	has_arrived = true
	_stop()

	match arrival_type:
		ArrivalType.PLAYER:
			state_machine.change_state("ArrivedPlayerState")

		ArrivalType.LEFT:
			state_machine.change_state("ArrivedSideState")

		ArrivalType.CENTER:
			state_machine.change_state("immunestate")

		ArrivalType.RIGHT:
			state_machine.change_state("ArrivedSideState")

# =============================
#        HELPERS
# =============================
func _stop() -> void:
	character.velocity = Vector2.ZERO

func _reset_state() -> void:
	has_arrived = false
	bobbing_time = 0.0
	movement_phase = 0
	pause_timer = 0.0
	arrival_type = ArrivalType.CENTER
