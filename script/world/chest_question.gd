extends Control

signal chest_closed(is_correct: bool)

@onready var question_label: Label = $Panel/ScrollContainer/question
@onready var answer_input: LineEdit = $Panel/answer

var correct_answers: Array[String]

func open_chest_ui(chest_question: String, chest_answers: Array[String]) -> void:
	question_label.text = chest_question
	correct_answers = chest_answers

func _on_close_pressed() -> void:
	var is_correct = _is_answer_correct(answer_input.text)
	chest_closed.emit(is_correct)
	call_deferred("queue_free")

func _on_submit_pressed() -> void:
	if _is_answer_correct(answer_input.text):
		print("correct")

func _is_answer_correct(answer_text: String) -> bool:
	return answer_text in correct_answers
