extends ProgressBar

@onready var character: CharacterBody2D = get_parent()

func _ready() -> void:
	character.health_changed.connect(update_health)
	update_health()

func update_health():
	var health_percent := float(character.current_health) / float(character.max_health)
	value = health_percent * 100.0
