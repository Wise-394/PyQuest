extends TextureProgressBar

@export var character: Node
@export var offset_percent: float = 16.7

func _ready() -> void:
	character.health_changed.connect(update_health)
	update_health()

func update_health():
	var health_percent = float(character.current_health) / float(character.max_health)
	value = offset_percent + (health_percent * (100.0 - offset_percent))
	
