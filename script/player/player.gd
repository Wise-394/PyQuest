# Player script for state machine

extends CharacterBody2D

@export var gravity: float = 1000
@export var speed: float = 300
@export var jump_strength = 400
@export var air_speed = 350
@export var cayote_time = 0.2
@onready var player_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine = $StateMachine

func _ready():
	# Start the state machine at its initial state
	if state_machine and state_machine.initial_state:
		state_machine.change_state(state_machine.initial_state.name.to_lower())
