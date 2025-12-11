extends Control

signal explanation_closed
@onready var label: RichTextLabel = $Panel/RichTextLabel
func _on_close_pressed() -> void:
	explanation_closed.emit()
	call_deferred("free")

func initialize(text):
	label.bbcode_enabled = true   # <- Enable BBCode
	label.bbcode_text = text      # <- Use bbcode_text instead of text
	label.bbcode_text = text
