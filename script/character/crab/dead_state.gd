extends State

@onready var timer: Timer = $Timer

func enter():
	init_references()
	character.is_alive = false
	character.is_invulnerable = true
	character.velocity = Vector2(0, -100)
	character.gravity = 400 
	hurtbox.disabled = true
	character.health_bar.visible = false 
	
	if not sprite.animation_finished.is_connected(_on_animation_finished):
		sprite.animation_finished.connect(_on_animation_finished)
	sprite.play("dead")
	timer.start()

func physics_update(delta: float):
	character.velocity.y += character.gravity * delta
	character.move_and_slide()

func _on_animation_finished() -> void:
	if sprite.animation == "dead":
		hurtbox.disabled = true

func _on_timer_timeout() -> void:
	character.queue_free()
