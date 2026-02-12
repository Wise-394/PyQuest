extends CharacterBody2D
@onready var state_machine: StateMachine = $FSM
@onready var sprite: AnimatedSprite2D = $PivotNode/AnimatedSprite2D
@onready var hitbox: Area2D = get_node_or_null("Hitbox")
@onready var hurtbox: CollisionPolygon2D = $HurtBox
@onready var cayote_time: float = 0
@onready var raycast_left = $RayCastLeft
@onready var raycast_right = $RayCastRight
@onready var health_bar = get_node_or_null("EnemyHealthBar")
@onready var pivot: Node2D = $PivotNode
@export var player: CharacterBody2D
@export var max_health = 50
@export var speed = 50.00
@export var gravity := 1000
@export var damage = 30
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
		
func _initialize_state_machine() -> void:
	if state_machine and state_machine.initial_state:
		state_machine.change_state(state_machine.initial_state.name.to_lower())
