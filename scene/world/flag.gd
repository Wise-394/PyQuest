extends Area2D


@export var children: Array[Node]


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		for child in children:
			if not child.is_completed:
				print("not completed yet")
				return
		end_level()


func end_level():
	print("everything finished")
