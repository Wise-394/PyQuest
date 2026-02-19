extends Panel

@onready var username_textbox := $UserNameTextBox

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
