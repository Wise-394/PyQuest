extends State

@export var bob_amplitude := 10.0   
@export var bob_speed := 1.0
@export var spawn_min_x := 140.0
@export var spawn_max_x := 740.0
@export var spawn_y := 140.0

var coding_zone: PackedScene = preload("res://scene/world/coding_zone.tscn")
var zone_instance = null
var bob_time := 0.0

func enter():
	init_references()
	sprite.play("immune")
	_reset_bobbing()
	_spawn_coding_zone()

func physics_update(delta):
	_update_bobbing(delta)
	character.move_and_slide()

func exit():
	if zone_instance.completed_signal.is_connected(completed_zone):
		zone_instance.completed_signal.disconnect(completed_zone)
func _reset_bobbing():
	bob_time = 0.0

func _update_bobbing(delta):
	bob_time += delta * bob_speed
	_apply_bobbing_velocity()

func _apply_bobbing_velocity():
	character.velocity.y = sin(bob_time) * bob_amplitude

func _spawn_coding_zone():
	zone_instance = coding_zone.instantiate()
	var random_x = randf_range(spawn_min_x, spawn_max_x)
	zone_instance.position = Vector2(random_x, spawn_y)
	zone_instance.level = 1
	zone_instance.question_id = 1
	#zone_instance.level = 10
	#zone_instance.question_id = randi_range(1,10)
	
	if not zone_instance.completed_signal.is_connected(completed_zone):
		zone_instance.completed_signal.connect(completed_zone)
	get_tree().current_scene.add_child(zone_instance)
	
func completed_zone():
	state_machine.change_state("idlestate")
	
