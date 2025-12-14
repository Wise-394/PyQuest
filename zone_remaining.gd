extends Label


@export var children: Array[Node]

func _ready() -> void:
	text = str(children.size())
	
func get_not_completed_count() -> int:
	var count := 0
	for child in children:
		if not child.is_completed:
			count += 1
	return count

func update_count():
	text = str(get_not_completed_count())
