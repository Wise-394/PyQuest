extends CharacterBody2D

@export var max_push_speed := 200.0  # maximum push speed
@export var push_accel := 600.0      # acceleration when pushed
@export var friction := 800.0        # slow down when not pushed
@export var gravity := 980.0         # vertical gravity

var pushing := false
var direction := Vector2.ZERO

func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	# Horizontal movement
	if pushing:
		velocity.x = move_toward(velocity.x, direction.x * max_push_speed, push_accel * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)

	move_and_slide()

# Signals
func _on_left_body_entered(body: Node2D) -> void:
	if body.name == "player":
		pushing = true
		direction = Vector2(1, 0)  # push to right

func _on_left_body_exited(body: Node2D) -> void:
	if body.name == "player":
		pushing = false

func _on_right_body_entered(body: Node2D) -> void:
	if body.name == "player":
		pushing = true
		direction = Vector2(-1, 0)  # push to left

func _on_right_body_exited(body: Node2D) -> void:
	if body.name == "player":
		pushing = false
