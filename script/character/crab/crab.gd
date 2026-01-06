extends CharacterBody2D

# --- Nodes ---
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurtbox: CollisionShape2D = $HurtBox
@onready var hitbox: Area2D = $HitBox
@onready var state_machine: Node = $StateMachine
@onready var raycast_left: RayCast2D = $RaycastLeft
@onready var raycast_right: RayCast2D = $RaycastRight
@onready var cayote_time = 0
@onready var health_bar = $EnemyHealthBar
# --- Exports ---
@export var direction := -1  # -1 = left, 1 = right
@export var speed := 100
@export var gravity := 1000
@export var max_health := 100
@export var damage = 25
#signal
signal direction_changed
signal health_changed
# --- State ---
var current_health = max_health
var is_alive := true
var can_change_direction := true
var is_invulnerable := false
var hit_direction := 1
var player: CharacterBody2D
# --- Initialization ---
func _ready() -> void:
	_initialize_state_machine()
	update_direction()
	hitbox.monitoring = false
	health_bar.visible = false


	
func _initialize_state_machine() -> void:
	if state_machine and state_machine.initial_state:
		state_machine.change_state(state_machine.initial_state.name.to_lower())

# --- Damage / Knockback ---
func damaged(damage_amount: int, attacker: Node2D) -> void:
	if not health_bar.visible:
		health_bar.visible = true

	if not is_alive:
		return

	_calculate_hit_direction(attacker)
	current_health -= damage_amount

	if current_health <= 0:
		death()
	else:
		player = attacker
		state_machine.change_state("damagedstate")
	health_changed.emit()

func _calculate_hit_direction(attacker: Node2D) -> void:
	hit_direction = sign(global_position.x - attacker.global_position.x)
	if hit_direction == 0:
		hit_direction = 1

func death() -> void:
	is_alive = false
	state_machine.change_state("damagedstate")

# --- Direction Handling ---
func update_direction() -> void:
	if not can_change_direction:
		return
	sprite.flip_h = direction > 0
	hitbox.scale.x = 1 if direction > 0 else -1
	direction_changed.emit(direction)
	
