extends Area2D

var direction = 1  # 1 = right, -1 = left
@export var speed = 350.0  # pixels per second
@export var max_distance = 850.0  # distance before despawn
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var distance_traveled = 0.0  # tracks distance
signal golem_arm_despawned
func _ready() -> void:
	_update_sprite_flip()

func _process(delta: float) -> void:
	var movement = direction * speed * delta
	position.x += movement
	distance_traveled += abs(movement)

	_update_sprite_flip()

	# Despawn after traveling max_distance
	if distance_traveled >= max_distance:
		golem_arm_despawned.emit()
		queue_free()  # removes this node from scene

func _update_sprite_flip() -> void:
	sprite.flip_h = direction == -1
