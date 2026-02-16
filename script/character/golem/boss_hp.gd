extends ProgressBar

@export var character: CharacterBody2D
@export var txt: String
@onready var label:Label = $Label
func _ready() -> void:
	label.text = txt
	character.health_changed.connect(update_health)
	update_health()

func update_health():
	var health_percent := float(character.current_health) / float(character.max_health)
	value = health_percent * 100.0
