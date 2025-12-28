extends Area2D


@onready var character = $".."

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and character.is_alive:
		body.character_damaged(character.damage, self)
