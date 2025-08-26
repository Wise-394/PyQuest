extends Area2D

@export var speed = 300
var direction: String
func _physics_process(delta: float) -> void:
	if direction == "left":
		position.x -= speed * delta
	elif direction == "right":
		position.x += speed * delta


func _on_despawn_timer_timeout() -> void:
	queue_free()
