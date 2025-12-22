extends StaticBody2D

@onready var cannon_ammo: PackedScene = load("res://scene/world/cannon_ammo.tscn")
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var spawn_point: Marker2D = $Marker2D

@export var direction: String = "left"
@export var fire_rate: float = 1.0

func _ready() -> void:
	_setup_direction()
	animated_sprite.animation_finished.connect(_on_animation_finished)
	_start_cycle()

func _setup_direction() -> void:
	if direction == "right":
		animated_sprite.flip_h = true
		# Flip the spawn point marker to match the cannon direction
		spawn_point.position.x = abs(spawn_point.position.x)
	else:
		spawn_point.position.x = -abs(spawn_point.position.x)

func _start_cycle() -> void:
	animated_sprite.play("fire")

func _on_animation_finished() -> void:
	if animated_sprite.animation == "fire":
		_spawn_ammo()
		animated_sprite.play("idle")
		_fire_again()

func _spawn_ammo() -> void:
	if not cannon_ammo:
		push_error("Cannon ammo scene not loaded!")
		return
	
	var new_ammo = cannon_ammo.instantiate()
	new_ammo.direction = direction
	
	# Use the marker's global transform for proper positioning and rotation
	new_ammo.global_position = spawn_point.global_position
	new_ammo.global_rotation = spawn_point.global_rotation
	
	get_tree().current_scene.add_child(new_ammo)

func _fire_again() -> void:
	await get_tree().create_timer(fire_rate).timeout
	_start_cycle()
