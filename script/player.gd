extends CharacterBody2D

# =====================================================
# --- Player ---
# =====================================================
enum PlayerState { IDLE, WALK, JUMP, DIALOGUE, CONSOLE, DROP }
var current_state: PlayerState = PlayerState.IDLE
@onready var animated_sprite = $AnimatedSprite2D

# =====================================================
# --- variables ---
# =====================================================
@export var move_speed: float = 200.0
@export var jump_force: float = -300.0
@export var gravity: float = 800.0

# =====================================================
# --- Ready ---
# =====================================================
func _ready() -> void:
	DialogueManager.dialogue_started.connect(on_dialogue_started)
	DialogueManager.dialogue_ended.connect(on_dialogue_ended)
	
# =====================================================
# --- Physics Process Loop ---
# =====================================================
func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	# DFA BY SIR JERUM
	#State machine that manages different player state
	match current_state:
		PlayerState.IDLE:
			_handle_idle_state()
		PlayerState.WALK:
			_handle_walk_state()
		PlayerState.JUMP:
			_handle_jump_state()
		PlayerState.DIALOGUE:
			_handle_dialogue_state()
		PlayerState.CONSOLE:
			_handle_console_state()
		PlayerState.DROP:
			_handle_drop_state()
			

	move_and_slide()

# =====================================================
# --- State-Specific Handlers ---
# =====================================================


	

func _handle_idle_state() -> void:
	_handle_input_movement()
	_handle_input_jump()
	_handle_input_drop()
	if velocity.x != 0:
		_set_state(PlayerState.WALK)
	elif not is_on_floor():
		_set_state(PlayerState.JUMP)
	

func _handle_walk_state() -> void:
	_handle_input_movement()
	_handle_input_jump()
	_handle_input_drop()
	if velocity.x == 0:
		_set_state(PlayerState.IDLE)
	elif not is_on_floor():
		_set_state(PlayerState.JUMP)
		
func _handle_jump_state() -> void:
	_handle_input_movement()
	if is_on_floor():
		if velocity.x == 0:
			_set_state(PlayerState.IDLE)
		else:
			_set_state(PlayerState.WALK)
			
func _handle_drop_state() -> void:
	if is_on_floor():
		position.y += 1
		_set_state(PlayerState.JUMP)  

func _handle_dialogue_state() -> void:
	velocity.x = 0
	
	
func _handle_console_state() -> void:
	velocity.x = 0

# =====================================================
# --- Shared Helpers & State Changer ---
# =====================================================
func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

func _handle_input_movement() -> void:
	var input_dir := Input.get_axis("move_left", "move_right")
	velocity.x = input_dir * move_speed
	if input_dir > 0:
		animated_sprite.flip_h = false
	elif input_dir < 0:
		animated_sprite.flip_h = true

func _handle_input_jump() -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force
		

func _handle_input_drop() -> void:
	if Input.is_action_just_pressed("drop"):
		_set_state(PlayerState.DROP)

func _update_animation() -> void:
	var target_anim: String

	match current_state:
		PlayerState.IDLE:
			target_anim = "idle"
		PlayerState.WALK:
			target_anim = "walk"
		PlayerState.JUMP:
			target_anim = "jump"
		PlayerState.DIALOGUE:
			target_anim = "idle"
		_:
			target_anim = "idle"

	if animated_sprite.animation != target_anim:
		animated_sprite.animation = target_anim
		animated_sprite.play()
		
# A dedicated function to change the state
func _set_state(new_state: PlayerState) -> void:
	if current_state == new_state:
		return
	current_state = new_state
	_update_animation()

# =====================================================
# --- Signals ---
# =====================================================
func on_dialogue_started(_res):
	_set_state(PlayerState.DIALOGUE)

func on_dialogue_ended(_res):
	if is_on_floor():
		_set_state(PlayerState.IDLE)
	else:
		_set_state(PlayerState.JUMP)


func _on_console_console_closed(_id) -> void:
	_set_state(PlayerState.IDLE)


func _on_console_console_opened() -> void:
	_set_state(PlayerState.DIALOGUE)
