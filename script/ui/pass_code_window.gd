extends Control


@onready var textbox = $PassCodeWindow/UserNameTextBox
signal correct_passcode
func _on_cancel_button_pressed() -> void:
	queue_free()


func _on_confirm_button_pressed() -> void:
	var user_passcode = textbox.text
	if user_passcode == SaveLoad.data['passcode']:
		correct_passcode.emit()
		queue_free()
