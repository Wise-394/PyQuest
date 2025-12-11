extends Control

signal code_editor_closed(is_correct: bool, question_id: int)

@onready var code_edit: TextEdit = $Panel/MarginContainer/VBoxContainer/CodeContainer/CodeEdit
@onready var question_label: Label = $Panel/MarginContainer/VBoxContainer/QuestionContainer/QuestionLabel
@onready var output_label: Label = $Panel/MarginContainer/VBoxContainer/OutputContainer/OutputLabel
@onready var question_api = $QuestionApi

var question_id: int = 0
var answered_correct: bool = false


func _ready() -> void:
	question_api.get_question_completed.connect(_on_get_question_completed)
	question_api.post_question_completed.connect(_on_post_question_completed)
	visible = false


func open_editor(id: int) -> void:
	question_id = id
	question_api.get_question(id)
	visible = true


func _on_close_pressed() -> void:
	close_editor()


func close_editor() -> void:
	visible = false
	code_editor_closed.emit(answered_correct, question_id)

	# Reset local state
	code_edit.text = ""
	question_label.text = ""
	output_label.text = ""
	answered_correct = false
	question_id = 0


func _on_run_pressed() -> void:
	question_api.post_question(question_id, code_edit.text)


func _on_get_question_completed(question: String) -> void:
	question_label.text = question


func _on_post_question_completed(output: String, is_correct: bool) -> void:
	answered_correct = is_correct
	output_label.text = output
