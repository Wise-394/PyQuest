extends CharacterBody2D

# =====================================================
# --- Player ---
# =====================================================
enum PlayerState { IDLE, WALK, JUMP }
var current_state: PlayerState = PlayerState.IDLE
@onready var animated_sprite = $AnimatedSprite2D
# =====================================================
# --- Movement Settings ---
# =====================================================
@export var move_speed: float = 200.0
@export var jump_force: float = -300.0
@export var gravity: float = 800.0

# =====================================================
# --- Physics Process Loop ---
# =====================================================
func _physics_process(delta: float) -> void:
	_apply_gravity(delta) # Apply gravity once at the start of every frame

	match current_state:
		PlayerState.IDLE:  _state_idle()
		PlayerState.WALK:  _state_walk()
		PlayerState.JUMP:  _state_jump()

	move_and_slide() # Apply final velocity at the end of every frame

# =====================================================
# --- Shared Helpers ---
# =====================================================
func _apply_gravity(delta: float) -> void:
	if not is_on_floor(): # Only apply gravity if the player is in the air
		velocity.y += gravity * delta

func _apply_horizontal_movement() -> float:
	var input_dir := Input.get_axis("move_left", "move_right")
	velocity.x = input_dir * move_speed
	if velocity.x > 0:
		animated_sprite.flip_h = false
	if velocity.x < 0:
		animated_sprite.flip_h = true
	return input_dir

func _try_jump() -> bool:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force
		current_state = PlayerState.JUMP
		return true
	return false

	

# =====================================================
# --- State Functions ---
# =====================================================
func _state_idle() -> void:
	velocity.x = 0

	if _try_jump():
		return

	var input_dir := Input.get_axis("move_left", "move_right")
	if input_dir != 0:
		current_state = PlayerState.WALK
	
func _state_walk() -> void:
	if _try_jump():
		return

	var input_dir := _apply_horizontal_movement()

	if input_dir == 0:
		current_state = PlayerState.IDLE

func _state_jump() -> void:
	_apply_horizontal_movement()

	# Check for landing
	if is_on_floor():
		var input_dir := Input.get_axis("move_left", "move_right")
		current_state = PlayerState.WALK if input_dir != 0 else PlayerState.IDLE
