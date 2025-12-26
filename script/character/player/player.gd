extends CharacterBody2D

@export_group("Movement")
@export var speed: float = 300
@export var air_speed: float = 350
@export var jump_strength: float = 400

@export_group("Physics")
@export var gravity: float = 1000
@export var cayote_time: float = 0.2

@export_group("Health")
@export var max_health: int = 100

@onready var current_health: int = max_health
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine = $StateMachine
@onready var hitbox = $HitBox
@onready var hurtbox = $HurtBox
var coyote_timer := 0.0
var hit_direction := 1
var is_invulnerable := false

signal health_changed

func _ready() -> void:
	_initialize_state_machine()
	hitbox.monitoring = false

func character_damaged(damage: int, attacker: Node2D) -> void:
	if is_invulnerable:
		return
	
	_calculate_hit_direction(attacker)
	_apply_damage(damage)
	if _is_dead():
		character_dead()

func character_dead() -> void:
	get_tree().call_deferred("reload_current_scene")

func _initialize_state_machine() -> void:
	if state_machine and state_machine.initial_state:
		state_machine.change_state(state_machine.initial_state.name.to_lower())

func _calculate_hit_direction(attacker: Node2D) -> void:
	hit_direction = sign(global_position.x - attacker.global_position.x)
	if hit_direction == 0:
		hit_direction = 1

func _apply_damage(damage: int) -> void:
	state_machine.change_state("damagedstate")
	current_health -= damage
	health_changed.emit()

func _is_dead() -> bool:
	return current_health <= 0
