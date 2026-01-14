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
@export var move_speed := 200.0
@export var arrival_threshold := 5.0

@export_group("Player Offset")
@export var min_horizontal_offset := 40.0
@export var max_horizontal_offset := 80.0
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
	if randf() < 0.55:
		# 70% chance → player target
		target_position = player_target
		arrival_type = ArrivalType.PLAYER
	else:
		# 30% chance → choose a static target randomly
		target_position = STATIC_TARGETS.pick_random()
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
			var dy := intermediate_y - character.global_position.y
			if abs(dy) <= arrival_threshold:
				character.global_position.y = intermediate_y
				movement_phase = 1
			else:
				velocity.y = sign(dy) * move_speed

		1:
			var dx := target_position.x - character.global_position.x
			if abs(dx) <= arrival_threshold:
				character.global_position.x = target_position.x
				movement_phase = 2
				pause_timer = 0.0
			else:
				velocity.x = sign(dx) * move_speed

		2:
			if pause_timer < pause_before_descent:
				pause_timer += delta
			else:
				var dy := target_position.y - character.global_position.y
				if abs(dy) <= arrival_threshold:
					character.global_position.y = target_position.y
					_on_arrival()
				else:
					velocity.y = sign(dy) * move_speed * descent_speed_multiplier

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
			state_machine.change_state("arrivedplayerstate")

		ArrivalType.LEFT:
			state_machine.change_state("arrivedsidestate")

		ArrivalType.CENTER:
			state_machine.change_state("arrivedsidestate")

		ArrivalType.RIGHT:
			state_machine.change_state("arrivedsidestate")

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
