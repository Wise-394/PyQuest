extends Panel

@onready var list : VBoxContainer = $ScrollContainer/VBoxContainer

func add_announcement(text: String) -> void:
	var label := Label.new()
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD
	label.scale = Vector2(0.7, 0.7) 
	list.add_child(label)
	await get_tree().create_timer(0.05).timeout
	$ScrollContainer.scroll_vertical = $ScrollContainer.get_v_scroll_bar().max_value
