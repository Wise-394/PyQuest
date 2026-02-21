extends Panel
@onready var username_textbox := $UserNameTextBox
@onready var output_label := $outputlabel
signal delete_button_pressed()
signal add_passcode_pressed()

const MIN_LENGTH = 4
const MAX_LENGTH = 10

func _ready() -> void:
	refresh()

func refresh():
	username_textbox.text = SaveLoad.data['player_name']

func _on_save_button_pressed() -> void:
	var username = username_textbox.text

	if username.strip_edges() == "":
		output_label.text = "Username cannot be empty."
		return

	if " " in username:
		output_label.text = "No spaces allowed."
		return

	var regex = RegEx.new()
	regex.compile("[^a-zA-Z0-9_]")
	if regex.search(username):
		output_label.text = "No special characters allowed."
		return

	if username.length() < MIN_LENGTH:
		output_label.text = "Too short! Min %d characters." % MIN_LENGTH
		return

	if username.length() > MAX_LENGTH:
		output_label.text = "Too long! Max %d characters." % MAX_LENGTH
		return

	SaveLoad.data['player_name'] = username
	SaveLoad.save_slot()
	output_label.text = "Saved!"

func _on_add_passcode_button_pressed() -> void:
	add_passcode_pressed.emit()

func _on_delete_button_pressed() -> void:
	delete_button_pressed.emit()
