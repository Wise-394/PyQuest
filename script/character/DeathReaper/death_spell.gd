extends Area2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
var is_active = false
@export var damage: int = 20

func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite.animation == "opening":
		sprite.play("attack")
		is_active = true
		monitoring = true
	elif sprite.animation == "attack":
		is_active = false
		sprite.play("closing")
		monitoring = false
	else:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	body.character_damaged(damage, self)
