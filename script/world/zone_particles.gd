extends CPUParticles2D

@export var max_distance := 300.0
@onready var player := get_tree().current_scene.get_node("Player")

func _process(_delta):
	var dist = global_position.distance_to(player.global_position)

	if dist <= max_distance:
		emitting = true
	else:
		emitting = false

func disable():
	set_process(false)
	emitting = false
