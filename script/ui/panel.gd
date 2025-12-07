extends Panel

var dragging := false
var drag_offset := Vector2.ZERO

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
			if dragging:
				drag_offset = get_global_mouse_position() - global_position
	elif event is InputEventMouseMotion and dragging:
		global_position = get_global_mouse_position() - drag_offset
