extends Node

@onready var flag: PackedScene = preload("res://scene/world/flag.tscn")

@export var level_to_go: String = "res://scene/lvl/main_menu.tscn"
@export var boss: CharacterBody2D

func _ready() -> void:
	boss.finished.connect(spawn_flag)

func spawn_flag():
	var flag_instance = flag.instantiate()
	flag_instance.level_to_go = level_to_go
	flag_instance.global_position = Vector2(543, -62)
	get_tree().current_scene.add_child(flag_instance)
