extends TextureProgressBar


@export var character: Node

func _ready() -> void:
	character.health_changed.connect(update_health)
	update_health()

func update_health():
	value = character.current_health * 100 / character.max_health
