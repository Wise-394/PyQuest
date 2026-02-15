extends Area2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite.animation == "opening":
		sprite.play("attack")
		monitoring = true
	elif sprite.animation == "attack":
		sprite.play("closing")
		monitoring = false
	else:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	print(body, "death spell entered")
