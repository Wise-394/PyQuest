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
	
func _on_despawn_timer_timeout() -> void:
	_explode()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and animated_sprite.animation == "default":
		body.character_damaged(damage,self)
	_explode()


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.animation == "destroyed":
		queue_free()
