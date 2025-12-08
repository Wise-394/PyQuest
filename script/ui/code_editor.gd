extends Control

#@onready var reset_button = $Panel/MarginContainer/VBoxContainer/Header/Reset
#@onready var close_button = $Panel/MarginContainer/VBoxContainer/Header/Close
#@onready var run_button = $Panel/MarginContainer/VBoxContainer/Run
#@onready var code_edit = $Panel/MarginContainer/VBoxContainer/CodeContainer/CodeEdit
@onready var question_label = $Panel/MarginContainer/VBoxContainer/QuestionContainer/QuestionLabel
#@onready var output_label = $Panel/MarginContainer/VBoxContainer/OutputContainer/OutputLabel
@onready var get_question_request = $GetQuestion

signal code_editor_closed
var is_editor_visible := false

# -----------------------
# Connector/Hooks function
# -----------------------
func _ready() -> void:
	get_question_request.get_question_completed.connect(set_question)
	_set_editor_visible(false)

func _on_close_pressed() -> void:
	close_editor()


# -----------------------
# code editor visibility functions`
# -----------------------
func open_editor(id):
	get_question(id)
	_set_editor_visible(true)

func close_editor():
	_set_editor_visible(false)
	code_editor_closed.emit()
func _set_editor_visible(value: bool):
	is_editor_visible = value
	visible = value

# -----------------------
# question functions`
# -----------------------
func set_question(question):
	question_label.text = question
# -----------------------
# backend Functions
# -----------------------
func get_question(id):
	get_question_request.get_question(id)
