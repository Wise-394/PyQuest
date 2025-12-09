extends Path2D

@export var speed: float = 100.0  
@export var is_active: bool = true
@onready var follower: PathFollow2D = $PathFollow2D

var direction: int = 1  # 1 for forward, -1 for backward

func _ready() -> void:
	follower.loop = false 
	set_process(is_active)

func _process(delta: float) -> void:
	follower.progress += speed * delta * direction
	
	# Check if we've reached the end
	if follower.progress_ratio >= 1.0:
		direction = -1  # Reverse direction
		follower.progress_ratio = 1.0 
	
	# Check if we've reached the start
	elif follower.progress_ratio <= 0.0:
		direction = 1  # Forward direction
		follower.progress_ratio = 0.0 

func activate_process() -> void:
	is_active = true
	set_process(true)

func deactivate_process() -> void:
	is_active = false
	set_process(false)
