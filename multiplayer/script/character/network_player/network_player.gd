extends CharacterBody2D

@export_group("Movement")
@export var speed: float = 250
@export var air_speed: float = 350
@export var jump_strength: float = 400
@export_group("Physics")
@export var gravity: float = 1000
@export var cayote_time = 0.5
@onready var state_machine = $FSM
@onready var sprite: AnimatedSprite2D = $Visuals/Sprite2D
@onready var visuals = $Visuals
@onready var hitbox = null
@onready var hurtbox = $HurtBox
@onready var username_label = $UserName
@onready var camera = $Camera2D
# ───────────────────────────── lifecycle ─────────────────────────────
func _ready() -> void:
	var is_local := is_multiplayer_authority()
	state_machine.set_process(is_local)
	state_machine.set_physics_process(is_local)
	state_machine.set_process_input(is_local)
	
	camera.enabled = is_local

	if is_local:
		_initialize_state_machine()

	username_label.text = "Player " + str(get_multiplayer_authority())

# ───────────────────────────── misc ──────────────────────────────────
func _initialize_state_machine() -> void:
	if state_machine and state_machine.initial_state:
		state_machine.change_state(state_machine.initial_state.name.to_lower())

func change_direction(direction: float) -> void:
	if direction > 0:
		visuals.scale.x = 1
	elif direction < 0:
		visuals.scale.x = -1
