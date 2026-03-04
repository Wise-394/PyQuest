extends CharacterBody2D

# ─── Constants ───────────────────────────────────────────
const SPEED      := 200.0
const JUMP_FORCE := -400.0
const GRAVITY    := 980.0

# ─── Node References ─────────────────────────────────────
@onready var camera: Camera2D = $Camera2D
@onready var username_label := $UserName

# ─── Lifecycle ───────────────────────────────────────────
func _ready() -> void:
	var is_local := is_multiplayer_authority()
	camera.enabled = is_local
	set_physics_process(is_local)

	var player_id := get_multiplayer_authority()
	username_label.text = "Player " + str(player_id)
	
func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	_handle_movement()
	_handle_jump()
	move_and_slide()

# ─── Movement ────────────────────────────────────────────
func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta

func _handle_movement() -> void:
	var direction := Input.get_axis("move_left", "move_right")
	velocity.x = direction * SPEED

func _handle_jump() -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_FORCE
