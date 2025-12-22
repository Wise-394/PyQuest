extends Area2D

@export var speed = 300
@export var damage = 45
var direction: String
@onready var animated_sprite = $AnimatedSprite2D
func _physics_process(delta: float) -> void:
	if direction == "left" and not animated_sprite.animation == "destroyed":
		position.x -= speed * delta
	elif direction == "right" and not animated_sprite.animation == "destroyed":
		position.x += speed * delta

func _explode():
	animated_sprite.animation = "destroyed"

func _on_animation_finished():
	if animated_sprite.animation == "destroyed":
		queue_free()

func _on_despawn_timer_timeout() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		_explode()
		body.character_damaged(damage,self)
