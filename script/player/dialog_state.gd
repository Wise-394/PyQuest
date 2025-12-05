extends State
class_name DialogState

var character: CharacterBody2D
var sprite: AnimatedSprite2D

func enter():
	print("dialog entered")
	character = state_machine.player
	sprite = character.player_sprite
	sprite.play("idle")

func update(_delta) -> void:
	pass
	
func physics_update(_delta):
	pass

func handle_input(_event):
	pass
