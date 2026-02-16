extends State


var spawn_point: Vector2 = Vector2(260,22)
@onready  var coding_zone = preload("res://scene/world/coding_zone.tscn")
var instance = null

func enter():
	init_references()
	instance = coding_zone.instantiate()
	if not instance.completed_signal.is_connected(_is_completed):
		instance.completed_signal.connect(_is_completed)
	instance.global_position = spawn_point
	instance.level = randi_range(11,19)
	instance.question_id = randi_range(1,3)
	get_tree().current_scene.add_child(instance)


func exit():
	if instance.completed_signal.is_connected(_is_completed):
		instance.completed_signal.disconnect(_is_completed)

func _is_completed():
	state_machine.change_state('appearstate')
