extends Control

signal chest_closed
@onready var question_label: Label = $Panel/ScrollContainer/question
var is_correct = false
func open_question(question_str):
	question_label.text = question_str

func _on_close_pressed() -> void:
	chest_closed.emit(is_correct)
	call_deferred("close")
	
func close():
	queue_free()
