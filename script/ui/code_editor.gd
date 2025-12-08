extends Control

# -----------------------
# Node References
# -----------------------
@onready var code_edit: TextEdit = $Panel/MarginContainer/VBoxContainer/CodeContainer/CodeEdit
@onready var question_label: Label = $Panel/MarginContainer/VBoxContainer/QuestionContainer/QuestionLabel
@onready var output_label: Label = $Panel/MarginContainer/VBoxContainer/OutputContainer/OutputLabel
@onready var question_api = $QuestionApi

# -----------------------
# Signals
# -----------------------
signal code_editor_closed(is_correct: bool, question_id: int)

# -----------------------
# State Variables
# -----------------------
var is_editor_visible: bool = false
var is_answered_and_correct: bool = false
var question_id: int = 0

# -----------------------
# Godot Callbacks
# -----------------------
func _ready() -> void:
	# Connect API signals
	question_api.get_question_completed.connect(_on_get_question_completed)
	question_api.post_question_completed.connect(_on_post_question_completed)

	_set_editor_visible(false)

# -----------------------
# UI Button Handlers
# -----------------------
func _on_close_pressed() -> void:
	_reset_editor()
	_close_editor()


func _on_run_pressed() -> void:
	var code = code_edit.text
	_submit_code(question_id, code)

# -----------------------
# Editor Visibility
# -----------------------
func open_editor(id: int) -> void:
	question_id = id
	_get_question(id)
	_set_editor_visible(true)


func close_editor() -> void:
	_close_editor()


# -----------------------
# Internal Functions
# -----------------------
func _close_editor() -> void:
	if not visible:
		return

	_set_editor_visible(false)
	code_editor_closed.emit(is_answered_and_correct, question_id)

	# Reset state
	question_id = 0
	is_answered_and_correct = false


func _set_editor_visible(value: bool) -> void:
	is_editor_visible = value
	visible = value


func _reset_editor() -> void:
	code_edit.text = ""
	question_label.text = ""
	output_label.text = ""

# -----------------------
# Signal Handlers
# -----------------------
func _on_get_question_completed(question: String) -> void:
	question_label.text = question


func _on_post_question_completed(output: String, is_correct: bool) -> void:
	is_answered_and_correct = is_correct
	output_label.text = output

# -----------------------
# Backend API Calls
# -----------------------
func _get_question(id: int) -> void:
	question_api.get_question(id)


func _submit_code(id: int, code: String) -> void:
	question_api.post_question(id, code)
