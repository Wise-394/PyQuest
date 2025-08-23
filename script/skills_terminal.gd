extends CanvasLayer

signal skills_terminal_state_changed

var is_open: bool = false

func _ready() -> void:
	visible = false  

func toggle_terminal() -> void:
	if not is_open:
		open_terminal()
	else:
		close_terminal()

func open_terminal() -> void:
	visible = true
	is_open = true
	skills_terminal_state_changed.emit("opened")

func close_terminal() -> void:
	visible = false
	is_open = false
	skills_terminal_state_changed.emit("closed")

# Called by the close button
func _on_close_pressed() -> void:
	close_terminal()
