extends State

@export var death_knockback := Vector2(80, 120)
@export var ground_friction := 1200.0
@export var air_damping := 200.0

@onready var timer: Timer = $Timer

func enter() -> void:
	init_references()
	timer.start()
	_play_death_animation()
	_apply_death_knockback()

func physics_update(delta: float) -> void:
	_apply_gravity(delta)
	_apply_horizontal_damping(delta)
	_move()

# -----------------------
# Core behavior
# -----------------------

func _apply_gravity(delta: float) -> void:
	character.velocity.y += character.gravity * delta

func _apply_horizontal_damping(delta: float) -> void:
	var damping := ground_friction if character.is_on_floor() else air_damping
	character.velocity.x = move_toward(
		character.velocity.x,
		0,
		damping * delta
	)

func _move() -> void:
	character.move_and_slide()

func _apply_death_knockback() -> void:
	character.velocity = Vector2(
		character.hit_direction * death_knockback.x,
		-death_knockback.y
	)

func _play_death_animation() -> void:
	sprite.play("dead")


func _on_timer_timeout() -> void:
	var canvas_layer = get_tree().current_scene.get_node("UI/CanvasLayer")
	var death_screen = preload("res://scene/ui/death_screen.tscn").instantiate()
	canvas_layer.add_child(death_screen)
