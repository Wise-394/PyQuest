extends Area2D

@onready var golem: CharacterBody2D = get_parent()
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and golem.is_alive:
		body.character_damaged(20,self)
