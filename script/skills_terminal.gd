extends CanvasLayer

signal skills_terminal_opened
signal skills_terminal_closed

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
	skills_terminal_opened.emit()

func close_terminal() -> void:
	visible = false
	is_open = false
	skills_terminal_closed.emit()

# Called by the close button
func _on_close_pressed() -> void:
	close_terminal()
