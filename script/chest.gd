extends Area2D

@onready var console = get_parent().get_node("Console")
@onready var label = $Label
@onready var animated_sprite_2d = $AnimatedSprite2D
@export var caller_id: int

var is_chest_closed = true
var player_inside = false
var answer_correct = false  

func _ready() -> void:
	console.user_code_correct.connect(_on_console_user_code_correct)
	console.console_closed.connect(_on_console_closed)

func _process(_ddelta: float) -> void:
	if player_inside and Input.is_action_just_pressed("open_console") and is_chest_closed:
		console.open_console(caller_id)
		answer_correct = false  # reset each time console is opened

func _on_console_user_code_correct(signal_id: int) -> void:
	# mark correct but don’t open yet
	if signal_id == caller_id:
		answer_correct = true

func _on_console_closed(signal_id: int) -> void:
	# only open chest after console closes AND answer was correct
	if signal_id == caller_id and answer_correct and is_chest_closed:
		_open_chest()

func _open_chest() -> void:
	if is_chest_closed:
		animated_sprite_2d.animation = "open"
		is_chest_closed = false

func _on_body_entered(body: Node2D) -> void:
	if body.name != "player" and not is_chest_closed:
		return
	player_inside = true
	label.visible = true

func _on_body_exited(body: Node2D) -> void:
	if body.name != "player":
		return
	player_inside = false
	label.visible = false
