extends Area2D

@export var speed = -300
func _physics_process(delta: float) -> void:
	position += Vector2(speed * delta, 0)


func _on_despawn_timer_timeout() -> void:
	queue_free()
