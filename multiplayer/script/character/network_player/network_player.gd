extends CharacterBody2D
@export_group("Movement")
@export var speed: float = 250
@export var air_speed: float = 300
@export var jump_strength: float = 400
@export_group("Physics")
@export var gravity: float = 1000
@export var cayote_time = 0.5
@onready var state_machine = $FSM
@onready var sprite: AnimatedSprite2D = $Visuals/Sprite2D
@onready var visuals = $Visuals
@onready var hitbox = null
@onready var hurtbox = $HurtBox
@onready var username_label = $UserName
@onready var camera = $Camera2D
@onready var interact = $Interact
# ───────────────────────────── STATE ─────────────────────────────
var is_question_discovered = false
var is_code_checked = false
# ───────────────────────────── lifecycle ─────────────────────────────
func _ready() -> void:
	var is_local := is_multiplayer_authority()
	state_machine.set_process(is_local)
	state_machine.set_physics_process(is_local)
	state_machine.set_process_input(is_local)
	interact.visible = false
	camera.enabled = is_local
	if is_local:
		_initialize_state_machine()
		_broadcast_skin()
		SaveLoad.skin_equipped.connect(_on_skin_equipped)
	var id := get_multiplayer_authority()
	if id == 1:
		username_label.text = "Player " + str(id) + " [Host]"
	else:
		username_label.text = "Player " + str(id)
# ───────────────────────────── skin ──────────────────────────────────
func _on_skin_equipped(skin_id: String) -> void:
	_broadcast_skin()

func _broadcast_skin() -> void:
	var skin_id: String = SaveLoad.data.get("active_player_skin", "")
	_apply_skin.rpc(skin_id)

@rpc("any_peer", "call_local", "reliable")
func _apply_skin(skin_id: String) -> void:
	if skin_id.is_empty():
		return
	_load_skin(skin_id)

func _load_skin(skin_id: String) -> void:
	var item := ShopList.get_item(skin_id)
	if item.is_empty():
		return
	var path: String = item.get("file_path", "")
	if path.is_empty():
		return
	var frames = load(path)
	if frames is SpriteFrames:
		sprite.sprite_frames = frames
	else:
		push_warning("Player: file at '%s' is not a SpriteFrames resource." % path)
# ───────────────────────────── misc ──────────────────────────────────
func question_discovered(val: bool) -> void:
	is_question_discovered = val
	interact.visible = is_multiplayer_authority() and is_question_discovered and not is_code_checked
func code_checked(val: bool) -> void:
	is_code_checked = val
	interact.visible = is_multiplayer_authority() and is_question_discovered and not is_code_checked
func _initialize_state_machine() -> void:
	if state_machine and state_machine.initial_state:
		state_machine.change_state(state_machine.initial_state.name.to_lower())
func change_direction(direction: float) -> void:
	if direction > 0:
		visuals.scale.x = 1
	elif direction < 0:
		visuals.scale.x = -1
