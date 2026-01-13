extends State

@onready var golem_arm = preload("res://scene/character/golem_arm.tscn") 

# Slow, subtle bobbing
@export var bobbing_amplitude = 4.0    
@export var bobbing_frequency = 0.5

var bobbing_timer = 0.0
var original_position_y = 0.0
var is_bobbing = false  # only start bobbing after attack animation

func enter():
	init_references()
	sprite.play("range")
	original_position_y = character.position.y
	bobbing_timer = 0.0
	
	# Connect animation finished signal
	if not sprite.animation_finished.is_connected(_on_animation_finished):
		sprite.animation_finished.connect(_on_animation_finished)

func exit():
	character.position.y = original_position_y
	if sprite.animation_finished.is_connected(_on_animation_finished):
		sprite.animation_finished.disconnect(_on_animation_finished)

func physics_update(delta: float):
	if is_bobbing:
		bobbing_timer += delta
		var offset_y = sin(bobbing_timer * bobbing_frequency * PI * 2) * bobbing_amplitude
		character.position.y = original_position_y + offset_y

func _on_animation_finished():
	if sprite.animation == "range":
		_spawn_golem_arm()
		is_bobbing = true  # start bobbing after spawning arm

func _spawn_golem_arm():
	var arm_instance = golem_arm.instantiate()
	arm_instance.position = character.position 
	arm_instance.direction = character.direction
	arm_instance.golem_arm_despawned.connect(_end_attack)
	get_tree().current_scene.add_child(arm_instance)

func _end_attack():
	state_machine.change_state("idlestate")
