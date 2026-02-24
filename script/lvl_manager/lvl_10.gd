extends Node

@onready var health_potion: PackedScene = preload("res://scene/world/health_potion.tscn")
@onready var flag: PackedScene = preload("res://scene/world/flag.tscn")

@export var level_to_go: String = "res://scene/save/loading_screen.tscn"
@export var boss: CharacterBody2D

func _ready() -> void:
	boss.finished.connect(spawn_flag)

func spawn_flag():
	var flag_instance = flag.instantiate()
	SaveLoad.current_level = 11
	flag_instance.level_to_go = level_to_go
	flag_instance.global_position = Vector2(743, 71)
	get_tree().current_scene.add_child(flag_instance)

func _on_spawn_timer_timeout() -> void:
	if randf() > 0.4:
		return
	
	var potion = health_potion.instantiate()
	potion.global_position = Vector2(randf_range(130, 730), 140)
	add_child(potion)
