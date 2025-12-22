extends StaticBody2D

@onready var cannon_ammo: PackedScene = load("res://scene/world/cannon_ammo.tscn")
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var spawn_point: Marker2D = $Marker2D
@export var direction = "left"
@export var fire_rate: int

func _ready() -> void:
	if(direction == "right"):
		animated_sprite.flip_h = true
	animated_sprite.animation_finished.connect(_on_animation_finished)
	_start_cycle()

func _start_cycle() -> void:
	animated_sprite.play("fire")

func _on_animation_finished() -> void:
	if animated_sprite.animation == "fire":
		_spawn_ammo()
		animated_sprite.play("idle")
		_fire_again()


func _spawn_ammo() -> void:
	var new_ammo = cannon_ammo.instantiate()
	new_ammo.direction = direction
	get_tree().current_scene.add_child(new_ammo) 
	new_ammo.global_position = spawn_point.global_position
	

func _fire_again() -> void:
	await get_tree().create_timer(1.0).timeout
	_start_cycle()
