extends Area2D

# =========================
#        VARIABLES
# =========================
var direction := 1  # 1 = right, -1 = left

@export var speed := 350.0          # pixels per second
@export var max_distance := 850.0   # distance before despawn

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

var distance_traveled := 0.0

signal golem_arm_despawned


# =========================
#          READY
# =========================
func _ready() -> void:
	_apply_direction()


# =========================
#         PROCESS
# =========================
func _process(delta: float) -> void:
	var movement := direction * speed * delta
	position.x += movement
	distance_traveled += abs(movement)

	# Despawn after traveling max distance
	if distance_traveled >= max_distance:
		golem_arm_despawned.emit()
		queue_free()


# =========================
#      DIRECTION FLIP
# =========================
func _apply_direction() -> void:
	# Flips BOTH sprite and collision
	scale.x = direction
