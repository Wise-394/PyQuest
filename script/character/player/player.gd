# Player script for state machine

extends CharacterBody2D

@export var gravity: float = 1000
@export var speed: float = 300
@export var jump_strength = 400
@export var air_speed = 350
@export var cayote_time = 0.2
@export var max_health = 100
@onready var current_health = 100
var coyote_timer := 0.0
@onready var player_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine = $StateMachine

signal health_changed
func _ready():
	# Start the state machine at its initial state
	if state_machine and state_machine.initial_state:
		state_machine.change_state(state_machine.initial_state.name.to_lower())

func character_damaged(damage: int):
	state_machine.change_state("damagedstate")
	current_health -= damage
	update_health()
	if current_health <= 0:
		character_dead()
func update_health():
	health_changed.emit()

func character_dead():
	get_tree().call_deferred("reload_current_scene")
