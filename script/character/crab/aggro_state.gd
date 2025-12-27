extends State

# --- Configuration ---
const HORIZONTAL_TOLERANCE := 8
const EXCLAMATION_DURATION := 1.0
const ATTACK_RANGE := 42
const ATTACK_COOLDOWN := 1.0
const MAX_CHASE_DISTANCE := 200
const MAX_VERTICAL_DISTANCE := 100

# --- Node references ---
@onready var exclamation_sprite: AnimatedSprite2D = $"../../Exclamation"
var exclamation_timer: Timer

# --- State variables ---
var attack_cooldown_timer := 0.0

# --- Lifecycle ---
func _ready():
	_setup_exclamation_timer()

func enter():
	init_references()
	_show_exclamation()

func physics_update(delta: float):
	if not _can_act():
		return
	
	_apply_gravity(delta)
	attack_cooldown_timer = max(0, attack_cooldown_timer - delta)
	
	if _should_de_aggro():
		_de_aggro()
		return
	
	if _try_attack():
		return
	
	_chase_player()
	
	# Check edge BEFORE moving
	if _is_at_edge():
		_de_aggro()
		return
	
	_move_and_check_edges()

func exit():
	_hide_exclamation()

# --- Exclamation ---
func _setup_exclamation_timer() -> void:
	exclamation_timer = Timer.new()
	exclamation_timer.wait_time = EXCLAMATION_DURATION
	exclamation_timer.one_shot = true
	exclamation_timer.timeout.connect(_hide_exclamation)
	add_child(exclamation_timer)

func _show_exclamation() -> void:
	exclamation_sprite.visible = true
	exclamation_sprite.play("default")
	exclamation_timer.start()

func _hide_exclamation() -> void:
	exclamation_sprite.visible = false

# --- De-Aggro Logic ---
func _should_de_aggro() -> bool:
	if not character.player:
		return false
	
	var horizontal_distance = abs(character.player.global_position.x - character.global_position.x)
	var vertical_distance = abs(character.player.global_position.y - character.global_position.y)
	
	return (
		horizontal_distance > MAX_CHASE_DISTANCE or
		vertical_distance > MAX_VERTICAL_DISTANCE or
		_is_at_edge()
	)

func _is_at_edge() -> bool:
	if not character.is_on_floor():
		return false
	
	# Raycasts should point DOWN to detect floor edges
	# Left raycast checks left edge, right raycast checks right edge
	var moving_left = character.direction < 0
	var moving_right = character.direction > 0
	
	# If moving left and left raycast doesn't detect ground = edge
	if moving_left and not character.raycast_left.is_colliding():
		return true
	
	# If moving right and right raycast doesn't detect ground = edge
	if moving_right and not character.raycast_right.is_colliding():
		return true
	
	return false

func _de_aggro() -> void:
	character.velocity.x = 0
	character.state_machine.change_state("idlestate")

# --- Attack Logic ---
func _try_attack() -> bool:
	if attack_cooldown_timer > 0:
		return false
	
	var distance = character.global_position.distance_to(character.player.global_position)
	
	if distance <= ATTACK_RANGE:
		character.state_machine.change_state("anticipationstate")
		attack_cooldown_timer = ATTACK_COOLDOWN
		return true
	
	return false

# --- Chase Logic ---
func _chase_player() -> void:
	if not character.player:
		return
	
	var x_diff = character.player.global_position.x - character.global_position.x
	
	if abs(x_diff) > HORIZONTAL_TOLERANCE:
		_move_towards_player(x_diff)
	else:
		_stop_moving()

func _move_towards_player(x_diff: float) -> void:
	_set_direction(sign(x_diff))
	character.velocity.x = character.speed * character.direction
	_play_animation("walk")

func _stop_moving() -> void:
	character.velocity.x = 0
	_play_animation("idle")

# --- Movement ---
func _move_and_check_edges() -> void:
	character.move_and_slide()

# --- Utility ---
func _can_act() -> bool:
	return character.is_alive and character.player != null

func _apply_gravity(delta: float) -> void:
	character.velocity.y += character.gravity * delta

func _set_direction(new_dir: int) -> void:
	if character.direction != new_dir:
		character.direction = new_dir
		character.update_direction()

func _play_animation(anim_name: String) -> void:
	if sprite.animation != anim_name:
		sprite.play(anim_name)
