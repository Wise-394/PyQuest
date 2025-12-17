extends Control

signal chest_closed
@onready var question_label: Label = $Panel/ScrollContainer/question
@onready var answer: LineEdit = $Panel/answer
var question_text
var correct_answer
var is_correct = false

func _on_close_pressed() -> void:
	chest_closed.emit(is_correct)
	call_deferred("close")
	
func close():
	queue_free()

func open_chest_ui(chest_question, chest_answer):
	question_label.text = chest_question
	correct_answer = chest_answer

func _is_answer_correct(answer_text):
	for correct in correct_answer:
		if answer_text == correct:
			return true
	return false


func _on_submit_pressed() -> void:
	is_correct = _is_answer_correct(answer.text)
	if is_correct:
		print("explain its correct")
