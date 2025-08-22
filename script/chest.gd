extends Area2D

# =====================================================
# --- Nodes ---
# =====================================================
@onready var console: Node = get_parent().get_node("Console")
@onready var label: Label = $Label
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# =====================================================
# --- Exported Variables ---
# =====================================================
@export var caller_id: int  # ID of the chest / question

# =====================================================
# --- State Variables ---
# =====================================================
var is_chest_closed: bool = true
var player_inside: bool = false
var answer_correct: bool = false  # tracks if the player solved the chest

# =====================================================
# --- Lifecycle ---
# =====================================================
func _ready() -> void:
	console.user_code_correct.connect(_on_console_user_code_correct)
	console.console_closed.connect(_on_console_closed)

func _process(_delta: float) -> void:
	# Open the console only if the player is inside, presses the key, and the chest is closed
	if player_inside and Input.is_action_just_pressed("open_console") and is_chest_closed:
		console.open_console(caller_id)

# =====================================================
# --- Console Signal Handlers ---
# =====================================================
func _on_console_user_code_correct(signal_id: int) -> void:
	if signal_id == caller_id:
		answer_correct = true  # mark as correct, chest will open after console closes

func _on_console_closed(signal_id: int) -> void:
	# Open the chest only once when the correct code was submitted
	if signal_id == caller_id and answer_correct and is_chest_closed:
		_open_chest()

# =====================================================
# --- Chest Control ---
# =====================================================
func _open_chest() -> void:
	if is_chest_closed:
		animated_sprite_2d.animation = "open"
		is_chest_closed = false
		label.visible = false

# =====================================================
# --- Player Detection ---
# =====================================================
func _on_body_entered(body: Node2D) -> void:
	if body.name != "player" or not is_chest_closed:
		return
	player_inside = true
	label.visible = true

func _on_body_exited(body: Node2D) -> void:
	if body.name != "player":
		return
	player_inside = false
	label.visible = false
