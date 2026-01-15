extends RayCast2D

@export var cast_speed := 400.0
@export var max_length := 850.0
@export var direction := 1  # 1 = right, -1 = left

@onready var line: Line2D = $Line2D
@onready var particles: CPUParticles2D = $HitParticles


func _ready() -> void:
	enabled = true
	target_position = Vector2.ZERO

	# Initialize laser line
	line.points = [
		Vector2.ZERO,
		Vector2.ZERO
	]


func _physics_process(delta: float) -> void:
	_extend_laser(delta)
	_update_laser_visuals()
	damage_player()

# -----------------------------
# Laser logic
# -----------------------------
func _extend_laser(delta: float) -> void:
	var target_x = max_length * direction

	target_position.x = move_toward(
		target_position.x,
		target_x,
		cast_speed * delta
	)

	force_raycast_update()

func damage_player():
	if is_colliding():
		var body = get_collider()
		if body.is_in_group("player"):
			body.character_damaged(20,self)


func _update_laser_visuals() -> void:
	var end_point := target_position
	var hit := false

	if is_colliding():
		end_point = to_local(get_collision_point())
		hit = true

	# Update line
	line.points = [
		Vector2.ZERO,
		end_point
	]

	# Update hit particles
	particles.position = end_point
	particles.emitting = hit
