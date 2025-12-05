extends Node


class_name State

var state_machine: StateMachine

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
	
func change_direction(direction: float, sprite: AnimatedSprite2D) -> void:
	if direction > 0:
		sprite.flip_h = false
	elif direction < 0:
		sprite.flip_h = true
