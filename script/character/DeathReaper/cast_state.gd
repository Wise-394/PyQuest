extends State


var death_spell_tscn = preload("res://scene/character/death_spell.tscn")
var x = [80, 473]
var y = -18
func enter():
	init_references()
	if not sprite.animation_finished.is_connected(_animation_finished):
		sprite.animation_finished.connect(_animation_finished)
	sprite.play("cast")
	

func exit():
	if sprite.animation_finished.is_connected(_animation_finished):
		sprite.animation_finished.disconnect(_animation_finished)
	

func spawn_spell(spawn_x: float):
	var instance = death_spell_tscn.instantiate()
	instance.global_position = Vector2(spawn_x, y)
	get_tree().current_scene.add_child(instance)

func get_random_x(existing_positions: Array, min_distance: float) -> float:
	var spawn_x = randf_range(x[0], x[1])
	while true:
		spawn_x = randf_range(x[0], x[1])
		var too_close = false
		for pos in existing_positions:
			if abs(spawn_x - pos) < min_distance:
				too_close = true
				break
		if not too_close:
			break
	return spawn_x

func _animation_finished():
	var spawned_positions = []
	for i in 3:
		var spawn_x = get_random_x(spawned_positions, 50.0)
		spawned_positions.append(spawn_x)
		spawn_spell(spawn_x)
	state_machine.change_state('idlestate')
	
