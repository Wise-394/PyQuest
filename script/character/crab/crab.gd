extends CharacterBody2D
@onready var sprite = $AnimatedSprite2D
@onready var hurtbox = $HurtBox
@onready var hitbox = $HitBox
@onready var state_machine = $StateMachine
@onready var cayote_time = 0
@onready var raycast_left = $RaycastLeft
@onready var raycast_right= $RaycastRight

@export var direction = -1  # -1 = left, 1 = right
@export var speed = 100
@export var gravity: float = 1000
@export var health: float = 100

func _ready() -> void:
	_initialize_state_machine()
	update_direction()

func _initialize_state_machine() -> void:
	if state_machine and state_machine.initial_state:
		state_machine.change_state(state_machine.initial_state.name.to_lower())

func damaged(damage_to_reduce):
	health -= damage_to_reduce
	if health <= 0:
		death()

func death():
	queue_free()
func update_direction() -> void:
	if direction > 0: 
		sprite.flip_h = true 
		hitbox.scale.x = 1
	else:
		sprite.flip_h = false
		hitbox.scale.x = -1
