extends RayCast2D

@export var cast_speed := 400.0
@export var max_length := 850.0
@export var direction := 1  # 1 = right, -1 = left

@onready var line: Line2D = $Line2D
@onready var particles: CPUParticles2D = $HitParticles

func _ready():
	target_position = Vector2.ZERO
	enabled = true

	line.points = [
		Vector2.ZERO,
		Vector2.ZERO
	]

func _physics_process(delta):
	# Extend laser
	var target = Vector2(max_length * direction, 0)
	target_position.x = move_toward(
		target_position.x,
		target.x,
		cast_speed * delta
	)

	force_raycast_update()

	# Determine laser end
	var end_point = target_position
	var hit := false

	if is_colliding():
		end_point = to_local(get_collision_point())
		hit = true

	# Update Line2D
	line.points = [
		Vector2.ZERO,
		end_point
	]

	# 🔥 Move particles to laser end
	particles.position = end_point
	particles.emitting = hit
