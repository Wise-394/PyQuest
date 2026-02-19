extends Panel

@onready var username_textbox := $UserNameTextBox
signal delete_button_pressed()
func _ready() -> void:
	refresh()

func refresh():
	username_textbox.text = SaveLoad.data['player_name']


func _on_save_button_pressed() -> void:
	var username = username_textbox.text
	if username == null or username == "":
		username = 'Player'
	SaveLoad.data['player_name'] = username
	SaveLoad.save_slot()


func _on_add_passcode_button_pressed() -> void:
	pass # Replace with function body.

func _on_delete_button_pressed() -> void:
	delete_button_pressed.emit()
