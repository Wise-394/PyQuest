extends State
class_name IdleState

var character: CharacterBody2D
var sprite: AnimatedSprite2D

func enter():
	character = state_machine.player
	sprite = character.player_sprite
	sprite.play("idle")

func physics_update(_delta):
	if not character.is_on_floor():
		state_machine.change_state("jumpstate")
		return

	var direction = Input.get_axis("move_left", "move_right")

	if direction != 0:
		state_machine.change_state("walkstate")
		return

	character.velocity.x = lerp(character.velocity.x, 0.0, 0.25)
	character.move_and_slide()

func handle_input(_event):
	if Input.is_action_just_pressed("jump"):
		state_machine.change_state("jumpstate")
