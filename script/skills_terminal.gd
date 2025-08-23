extends CanvasLayer

signal skills_terminal_state_changed

var is_open: bool = false
@onready var user_code = $Panel/user_code
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


func _on_run_pressed() -> void:
	pass
#TODO: take user code, check if valid code and what skills, 
#call global to activate the skills
