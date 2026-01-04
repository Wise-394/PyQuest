extends Area2D

@onready var character: CharacterBody2D = get_parent()

func _ready() -> void:
	character.direction_changed.connect(_on_direction_changed)
	

func _on_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		return
	
	character.player = body
	

func _on_direction_changed(direction: int) -> void:
	scale.x = -1 if direction > 0 else 1 
