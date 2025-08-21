extends Area2D

@onready var console = get_parent().get_node("Console")
@onready var label = $Label
@export var caller_id: int
var player_inside = false

func _ready() -> void:
	# Make sure this chest listens to the console signal
	if console and not console.user_code_correct.is_connected(_on_console_user_code_correct):
		console.user_code_correctd.connect(_on_console_user_code_correct)

func _process(_ddelta: float) -> void:
	if player_inside and Input.is_action_just_pressed("open_console"):
		console.open_console(caller_id)

func _on_body_entered(body: Node2D) -> void:
	if body.name != "player":
		return
	player_inside = true
	label.visible = true

func _on_body_exited(body: Node2D) -> void:
	if body.name != "player":
		return
	player_inside = false
	label.visible = false

func _on_console_user_code_correct(signal_id: int) -> void:
	if signal_id == caller_id:
		print("nice", caller_id)
		# open_chest() here
		
#have collection of questions
