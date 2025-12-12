extends Control

signal explanation_closed
@onready var label: RichTextLabel = $Panel/RichTextLabel
func _on_close_pressed() -> void:
	explanation_closed.emit()
	call_deferred("free")

func initialize(text):
	label.bbcode_enabled = true
	label.bbcode_text = text
	label.bbcode_text = text
