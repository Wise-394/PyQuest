extends CharacterBody2D
@onready var state_machine: StateMachine = $FSM
@onready var sprite: AnimatedSprite2D = $PivotNode/AnimatedSprite2D
@onready var hitbox: Area2D = $PivotNode/Hitbox
@onready var hurtbox: CollisionPolygon2D = $HurtBox
@onready var sword_hitbox: Area2D = $PivotNode/Sword_Hitbox
@onready var cayote_time: float = 0
@onready var raycast_left = $RayCastLeft
@onready var raycast_right = $RayCastRight
@onready var health_bar = get_node_or_null("EnemyHealthBar")
@onready var pivot: Node2D = $PivotNode
@export var player: CharacterBody2D
@export var max_health = 2500
@export var speed = 50.00
@export var gravity := 1000
@export var damage = 20
# --- Direction / Movement ---
var direction := -1                # Actual facing direction
var can_change_direction := true

# --- Signals ---
signal health_changed

# --- State ---
var is_invulnerable := false
var current_health = max_health
var is_alive := true


func _ready() -> void:
	_initialize_state_machine()
	sword_hitbox.monitoring = false
		
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
