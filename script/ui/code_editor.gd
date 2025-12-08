extends Control

#@onready var close_button = $Panel/MarginContainer/VBoxContainer/Header/Close
#@onready var run_button = $Panel/MarginContainer/VBoxContainer/Run
@onready var code_edit = $Panel/MarginContainer/VBoxContainer/CodeContainer/CodeEdit
@onready var question_label = $Panel/MarginContainer/VBoxContainer/QuestionContainer/QuestionLabel
@onready var output_label = $Panel/MarginContainer/VBoxContainer/OutputContainer/OutputLabel
@onready var question_api = $QuestionApi

signal code_editor_closed

var is_editor_visible := false
var is_answered_and_correct = false
var question_id = 0
# -----------------------
# Connector/Hooks function
# -----------------------
func _ready() -> void:
	question_api.get_question_completed.connect(get_question_completed)
	question_api.post_question_completed.connect(post_question_completed)
	_set_editor_visible(false)

func _on_close_pressed() -> void:
	# Cleanup/Reset happens before closing
	question_label.text = ""
	output_label.text = ""
	code_edit.text = ""
	
	close_editor() # Call the closing logic

func _on_run_pressed() -> void:
	var code = code_edit.text
	submit_code(question_id, code)
	
# -----------------------
# code editor visibility functions`
# -----------------------
func open_editor(id):
	question_id = id
	get_question(id)
	_set_editor_visible(true)

func close_editor():
	if visible:
		_set_editor_visible(false)
		code_editor_closed.emit(is_answered_and_correct, question_id)
		question_id = 0
		is_answered_and_correct = false
	# ------------------------
	
func _set_editor_visible(value: bool):
	is_editor_visible = value
	visible = value

# -----------------------
# signal functions`
# -----------------------
func get_question_completed(question):
	question_label.text = question

func post_question_completed(output, is_correct):
	is_answered_and_correct = is_correct
	output_label.text = output
# -----------------------
# backend Functions
# -----------------------
func get_question(id):
	question_api.get_question(id)
	
func submit_code(id, code):
	question_api.post_question(id, code)
