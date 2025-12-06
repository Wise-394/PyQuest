extends Node


class_name State

var state_machine: StateMachine
var character: CharacterBody2D
var sprite: AnimatedSprite2D
var coyote_time: float
func enter():
	pass
	
func exit():
	pass
	
func update(_delta: float):
	pass
	
func physics_update(_delta: float):
	pass
	
func handle_input(_event: InputEvent):
	pass
	
func change_direction(direction: float,) -> void:
	if direction > 0:
		sprite.flip_h = false
	elif direction < 0:
		sprite.flip_h = true
		
func init_references():
	character = state_machine.player
	sprite = character.player_sprite
	coyote_time = character.cayote_time
