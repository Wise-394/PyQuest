extends State

@onready var timer = $Timer
func enter():
	init_references()
	character.is_alive = false
	character.is_invulnerable = true

	if not sprite.animation_finished.is_connected(_on_animation_finished):
		sprite.animation_finished.connect(_on_animation_finished)

	sprite.play("dead")

func _on_animation_finished() -> void:
	if sprite.animation == "dead":
		hurtbox.disabled = true
		timer.start()
		



func _on_timer_timeout() -> void:
	character.queue_free()
