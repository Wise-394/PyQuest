extends State

# --- Exclamation config ---
@export var exclamation_duration: float = 0.8

@onready var exclamation_sprite: AnimatedSprite2D = $"../../Exclamation"
var exclamation_timer: Timer

func _ready():
	_setup_exclamation_timer()

func enter():
	init_references()

	_show_exclamation()

	if not sprite.animation_finished.is_connected(_on_animation_finished):
		sprite.animation_finished.connect(_on_animation_finished)

	sprite.play("anticipation")
	character.velocity.x = 0

func exit():
	if sprite.animation_finished.is_connected(_on_animation_finished):
		sprite.animation_finished.disconnect(_on_animation_finished)

	_hide_exclamation()

# --- Exclamation logic ---
func _setup_exclamation_timer():
	exclamation_timer = Timer.new()
	exclamation_timer.wait_time = exclamation_duration
	exclamation_timer.one_shot = true
	exclamation_timer.timeout.connect(_hide_exclamation)
	add_child(exclamation_timer)

func _show_exclamation():
	if exclamation_sprite:
		exclamation_sprite.visible = true
		exclamation_sprite.play("default")
		exclamation_timer.start()

func _hide_exclamation():
	if exclamation_sprite:
		exclamation_sprite.visible = false

# --- Animation ---
func _on_animation_finished():
	if sprite.animation == "anticipation":
		character.state_machine.change_state("attackstate")
