extends Control
@onready var text_edit := $Panel/TextEdit
@onready var output_label := $Panel/OutputLabel

const MIN_LENGTH = 4
const MAX_LENGTH = 10
signal password_confirmed
func _on_cancel_pressed() -> void:
	queue_free()

func _on_confirm_pressed() -> void:
	var passcode = text_edit.text

	if passcode == "":
		output_label.text = "Passcode cannot be empty."
		return

	if " " in passcode:
		output_label.text = "Passcode cannot contain spaces."
		return

	if passcode.length() < MIN_LENGTH:
		output_label.text = "Too short! Min %d characters." % MIN_LENGTH
		return

	if passcode.length() > MAX_LENGTH:
		output_label.text = "Too long! Max %d characters." % MAX_LENGTH
		return

	SaveLoad.data['passcode'] = passcode
	SaveLoad.save_slot()
	password_confirmed.emit()
	queue_free()
