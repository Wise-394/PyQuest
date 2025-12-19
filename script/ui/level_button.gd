extends Button

@export var level:int = 0

func _ready() -> void:
	text = str(level)
