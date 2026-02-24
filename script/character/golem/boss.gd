extends CharacterBody2D

# ===============================
# EXPORTS
# ===============================
@export var max_health: int = 1500
@export var speed: float = 50
@export var gravity: float = 1000
@export var damage: int = 30

@export var facing_smooth_speed: float = 12.0

@export var turn_speed: float = 8.0
@export var turn_delay: float = 0.12


# ===============================
# NODES
# ===============================
@onready var state_machine: StateMachine = $StateMachine
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $HitBox
@onready var hurtbox: CollisionShape2D = $HurtBox
@onready var raycast_left = null
@onready var raycast_right =  null
@onready var health_bar = null
@onready var laser_effect = $LaserEffect
@onready var active_hitbox = $ActiveHitBox
# ===============================
# STATE
# ===============================
var is_invulnerable: bool = false
var is_alive: bool = true
var current_health: int = 500
var hit_direction: int = 1
var player: CharacterBody2D = null
var direction = 1
var cayote_time = 0
var melee_attack = false
var laser_offset_x := 40.0
signal health_changed
signal finished
# ===============================
# LIFE CYCLE
# ===============================
func _ready() -> void:
	current_health = max_health
	_get_player()
	_initialize_state_machine()
	
# ===============================
# HELPER FUNCTIONS
# ===============================
func face_player() -> void:
	if not player:
		return

	var to_player := player.global_position.x - global_position.x
	if to_player == 0:
		return

	direction = sign(to_player)
	sprite.flip_h = direction < 0
	laser_effect.position.x = 6 if direction > 0 else -10
	hitbox.scale.x = abs(hitbox.scale.x) * direction


func _get_player() -> void:
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]

func _initialize_state_machine() -> void:
	if state_machine and state_machine.initial_state:
		state_machine.change_state(state_machine.initial_state.name.to_lower())
		
		
func damaged(damage_amount: int, _attacker: Node2D) -> void:
	if not is_alive:
		return

	current_health -= damage_amount
	health_changed.emit()
	if current_health <= 0:
		
		state_machine.change_state("deadstate")
