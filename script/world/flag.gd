extends Area2D


@onready var zone_remaining: Label = get_tree().current_scene.get_node("UI/CanvasLayer/ZoneRemaining")
func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if(zone_remaining.get_not_completed_count() <= 0):
			end_level()
		else:
			print("not completed")
		


func end_level():
	print("everything finished")
