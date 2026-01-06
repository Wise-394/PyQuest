extends CharacterBody2D
@onready var state_machine: StateMachine = $StateMachine
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $Hitbox
@onready var hurtbox: CollisionShape2D = $HurtBox
@onready var cayote_time: float = 0
@onready var raycast_left = $RaycastLeft
@onready var raycast_right = $RaycastRight
@onready var health_bar = $EnemyHealthBar 

@export var max_health = 50
@export var speed = 50
@export var gravity := 1000
@export var damage = 30

# --- Direction / Movement ---
var direction := 1                # Actual facing direction
var target_direction := 1         # Desired facing direction
@export var turn_speed := 8.0
@export var turn_delay := 0.12
var can_change_direction := true

# --- Signals ---
signal direction_changed(direction)
signal health_changed

# --- State ---
var is_invulnerable := false
var current_health = max_health
var is_alive := true
var hit_direction := 1
var player = null  # assign when player enters detection range

# -----------------------------
func _ready() -> void:
	_initialize_state_machine()
	if health_bar:
		health_bar.visible = false
		
func _initialize_state_machine() -> void:
	if state_machine and state_machine.initial_state:
		state_machine.change_state(state_machine.initial_state.name.to_lower())

# -----------------------------
# DAMAGE / KNOCKBACK
# -----------------------------
func damaged(damage_amount: int, attacker: Node2D) -> void:
	if health_bar and not health_bar.visible:
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

# -----------------------------
# SMOOTH DIRECTION HANDLING
# -----------------------------
func update_direction() -> void:
	sprite.flip_h = direction > 0
	hitbox.scale.x = 1
	direction_changed.emit(direction)

func request_direction(new_dir: int) -> void:
	if target_direction == new_dir:
		return
	target_direction = new_dir
	_smooth_turn()

func _smooth_turn() -> void:
	if not can_change_direction:
		return
	can_change_direction = false
	await get_tree().create_timer(turn_delay).timeout
	direction = target_direction
	update_direction()
	can_change_direction = true
