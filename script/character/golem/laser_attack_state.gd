extends State

var golem_laser = preload("res://scene/character/golem_laser.tscn")
@onready var timer: Timer = $Timer
var laser_instance: Node = null 

func enter():
	init_references()
	sprite.play("laser")
	character.laser_effect.visible = true
	character.laser_effect.play("default")
	if not sprite.animation_finished.is_connected(_on_animation_finished):
		sprite.animation_finished.connect(_on_animation_finished)

func exit():
	if sprite.animation_finished.is_connected(_on_animation_finished):
		sprite.animation_finished.disconnect(_on_animation_finished)
	character.laser_effect.visible = false

func _on_animation_finished():
	# Spawn laser
	laser_instance = golem_laser.instantiate()
	laser_instance.direction = character.direction
	var offset = Vector2(character.direction, -16)
	laser_instance.position = offset
	character.add_child(laser_instance)

	# Start timer to despawn laser
	timer.start()

func _on_timer_timeout() -> void:
	if laser_instance and laser_instance.is_inside_tree():
		laser_instance.queue_free()
		laser_instance = null
	state_machine.change_state("idlestate")	
	timer.stop()
