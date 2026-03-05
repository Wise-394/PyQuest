extends Button

var player_checklist = preload("res://scene/ui/player_check_list.tscn")

func _ready() -> void:
	visible = multiplayer.is_server()


func _on_pressed() -> void:
	var existing := get_parent().get_node_or_null("PlayerCheckList")
	if existing:
		existing.visible = not existing.visible
