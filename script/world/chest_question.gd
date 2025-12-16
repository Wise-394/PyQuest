extends Control

signal chest_closed


func open_question(question_str):
	var question: Label = $Panel/ScrollContainer/question
	question.text = question_str

func _on_close_pressed() -> void:
	chest_closed.emit()
	call_deferred("close")
	
func close():
	queue_free()
