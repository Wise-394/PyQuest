extends RayCast2D

@export var cast_speed := 400.0
@export var max_length := 850.0
@export var direction := 1  # 1 = right, -1 = left

@onready var line: Line2D = $Line2D

func _ready():
	# Start with zero-length ray
	target_position = Vector2.ZERO
	enabled = true

	# Initialize line properly
	line.points = [
		Vector2.ZERO,
		Vector2.ZERO
	]

func _physics_process(delta):
	# Extend target_position toward max_length
	var target = Vector2(max_length * direction, 0)
	target_position.x = move_toward(target_position.x, target.x, cast_speed * delta)

	# Force RayCast2D to recalc collisions
	force_raycast_update()

	# Update Line2D to match
	var end_point = target_position
	if is_colliding():
		end_point = to_local(get_collision_point())

	line.points = [
		Vector2.ZERO,
		end_point
	]
