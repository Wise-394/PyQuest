extends Area2D


@onready var character = $".."

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		area.damaged()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.damaged(character.damage, character)
