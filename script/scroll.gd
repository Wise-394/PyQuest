extends Area2D


@onready var animated_sprite = $AnimatedSprite2d

func _on_body_entered(body: Node2D) -> void:
	if animated_sprite.animation_finished and body.name == "player":
		var resource = load("res://dialogue/unlocked_place_platform.dialogue")
		DialogueManager.show_dialogue_balloon(resource,"start")
		queue_free()
