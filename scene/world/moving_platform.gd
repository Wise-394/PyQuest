extends Path2D


@export var speed = 100
@export var isActive = false

@onready var path = $PathFollow2D
@onready var animation = $AnimationPlayer
func _ready() -> void:
	path.rotates = false
	if isActive:
		animation.play("test_move")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func move_platform():
	isActive = true
	animation.play("test_move")
