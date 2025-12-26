extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var hurtbox = $HurtBox
@onready var hitbox = $HitBox
@onready var state_machine = $StateMachine
@onready var cayote_time = 0
func _ready() -> void:
	_initialize_state_machine()
	
	
func _initialize_state_machine() -> void:
	if state_machine and state_machine.initial_state:
		print("Crab")
		state_machine.change_state(state_machine.initial_state.name.to_lower())
