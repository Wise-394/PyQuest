extends Area2D



@onready var reaper = $"../.."

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.character_damaged(reaper.damage, reaper)
