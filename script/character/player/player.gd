extends CharacterBody2D

@export_group("Movement")
@export var speed: float = 300
@export var air_speed: float = 350
@export var jump_strength: float = 400
@export var damage: float = 35

@export_group("Physics")
@export var gravity: float = 1000
@export var cayote_time: float = 0.2

@export_group("Health")
@export var max_health: int = 100

@onready var current_health: int = max_health
@onready var sprite: AnimatedSprite2D = $Visuals/AnimatedSprite2D
@onready var state_machine = $StateMachine
@onready var hitbox = $HitBox
@onready var hurtbox = $HurtBox
@onready var visuals = $Visuals
var coyote_timer := 0.0
var hit_direction := 1
var is_invulnerable := false
var is_alive = true
signal health_changed

func _ready() -> void:
	_initialize_state_machine()
	hitbox.monitoring = false

func character_damaged(damage_to_reduce: int, attacker: Node2D) -> void:
	if is_invulnerable:
		return
	
	_calculate_hit_direction(attacker)
	_apply_damage(damage_to_reduce)

func _initialize_state_machine() -> void:
	if state_machine and state_machine.initial_state:
		state_machine.change_state(state_machine.initial_state.name.to_lower())

func _calculate_hit_direction(attacker: Node2D) -> void:
	hit_direction = sign(global_position.x - attacker.global_position.x)
	if hit_direction == 0:
		hit_direction = 1

func change_direction(direction: float) -> void:
	if direction > 0:
		visuals.scale.x = 1
		hitbox.scale.x = 1 
	elif direction < 0:
		visuals.scale.x =-1
		hitbox.scale.x = -1 

func heal(amount: int) -> void:
	current_health = min(current_health + amount, max_health)
	health_changed.emit()
	
func _apply_damage(damage_to_reduce: int) -> void:
	current_health -= damage_to_reduce
	health_changed.emit()
	
	state_machine.change_state("damagedstate")
