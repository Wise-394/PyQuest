# code_editor.gd
extends Control

signal code_editor_closed(is_correct: bool, explanation: String)

# REFERENCES
@onready var code_edit: TextEdit = $Panel/CodeEdit
@onready var question_label: Label = $Panel/QuestionLabel
@onready var output_label: Label = $Panel/ScrollContainer/OutputLabel
@onready var question_api = $QuestionApi

# STATE
var current_question_id := 0
var current_level = 0
var is_answer_correct := false
var current_explanation := ""

func _ready() -> void:
	question_api.get_question_completed.connect(_on_question_loaded)
	question_api.post_question_completed.connect(_on_answer_submitted)
	visible = false


# ----------------------------------------------------------
# OPEN EDITOR
# ----------------------------------------------------------
func open_editor(level: int, question_id: int) -> void:
	current_question_id = question_id
	current_level = level
	visible = true
	question_api.get_question(level, question_id)


# ----------------------------------------------------------
# QUESTION LOADED
# ----------------------------------------------------------
func _on_question_loaded(question_text: String) -> void:
	question_label.text = question_text


# ----------------------------------------------------------
# EXECUTE CODE
# ----------------------------------------------------------
func _on_run_pressed() -> void:
	question_api.post_question(current_level,current_question_id, code_edit.text)

func _on_answer_submitted(output: String, is_correct: bool, explanation: String) -> void:
	is_answer_correct = is_correct
	current_explanation = explanation
	output_label.text = output


# ----------------------------------------------------------
# CLOSE EDITOR
# ----------------------------------------------------------
func _on_close_pressed() -> void:
	visible = false
	code_editor_closed.emit(is_answer_correct, current_explanation)
	_reset_state()
	queue_free()

func _reset_state() -> void:
	code_edit.text = ""
	question_label.text = ""
	output_label.text = ""
	is_answer_correct = false
	current_explanation = ""
	current_question_id = 0
