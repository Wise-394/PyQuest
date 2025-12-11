# code_editor.gd
extends Control

# ============================================================================
# SIGNALS
# ============================================================================
signal code_editor_closed(is_correct: bool, explanation: String)

# ============================================================================
# NODE REFERENCES
# ============================================================================
@onready var code_edit: TextEdit = $Panel/MarginContainer/VBoxContainer/CodeContainer/CodeEdit
@onready var question_label: Label = $Panel/MarginContainer/VBoxContainer/QuestionContainer/QuestionLabel
@onready var output_label: Label = $Panel/MarginContainer/VBoxContainer/OutputContainer/OutputLabel
@onready var question_api = $QuestionApi

# ============================================================================
# STATE
# ============================================================================
var current_question_id: int = 0
var is_answer_correct: bool = false
var current_explanation: String = ""

# ============================================================================
# LIFECYCLE
# ============================================================================
func _ready() -> void:
	_initialize()

# ============================================================================
# INITIALIZATION
# ============================================================================
func _initialize() -> void:
	_connect_api_signals()
	visible = false

func _connect_api_signals() -> void:
	question_api.get_question_completed.connect(_on_question_loaded)
	question_api.post_question_completed.connect(_on_answer_submitted)

# ============================================================================
# PUBLIC API
# ============================================================================
func open_editor(question_id: int) -> void:
	current_question_id = question_id
	_load_question(question_id)
	_show_editor()

# ============================================================================
# EDITOR DISPLAY
# ============================================================================
func _show_editor() -> void:
	visible = true

func _hide_editor() -> void:
	visible = false

# ============================================================================
# QUESTION LOADING
# ============================================================================
func _load_question(question_id: int) -> void:
	question_api.get_question(question_id)

func _on_question_loaded(question_text: String) -> void:
	question_label.text = question_text

# ============================================================================
# CODE EXECUTION
# ============================================================================
func _on_run_pressed() -> void:
	_submit_code()

func _submit_code() -> void:
	question_api.post_question(current_question_id, code_edit.text)

func _on_answer_submitted(output: String, is_correct: bool, explanation: String) -> void:
	_update_result(output, is_correct, explanation)

func _update_result(output: String, is_correct: bool, explanation: String) -> void:
	is_answer_correct = is_correct
	current_explanation = explanation
	output_label.text = output

# ============================================================================
# CLOSING
# ============================================================================
func _on_close_pressed() -> void:
	_close_editor()

func _close_editor() -> void:
	_hide_editor()
	_emit_close_signal()
	_reset_state()

func _emit_close_signal() -> void:
	code_editor_closed.emit(is_answer_correct, current_explanation)

func _reset_state() -> void:
	code_edit.text = ""
	question_label.text = ""
	output_label.text = ""
	is_answer_correct = false
	current_explanation = ""
	current_question_id = 0
