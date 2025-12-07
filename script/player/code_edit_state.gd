extends State
class_name CodeEditState

func enter():
	init_references()
	sprite.play("idle")
	character.velocity.x = 0
	
func update(delta) -> void:
	character.velocity.y += character.gravity * delta
	character.move_and_slide()
	
func physics_update(_delta):
	pass

func handle_input(_event):
	pass
