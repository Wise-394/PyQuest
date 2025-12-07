extends Control

@onready var reset_button = $Panel/MarginContainer/VBoxContainer/Header/Reset
@onready var close_button = $Panel/MarginContainer/VBoxContainer/Header/Close
@onready var run_button = $Panel/MarginContainer/VBoxContainer/Run
@onready var code_edit = $Panel/MarginContainer/VBoxContainer/CodeContainer/CodeEdit
@onready var question_label = $Panel/MarginContainer/VBoxContainer/QuestionContainer/QuestionLabel
@onready var output_label = $Panel/MarginContainer/VBoxContainer/OutputContainer/OutputLabel

var is_visible_console := false


func _ready() -> void:
	_set_visibility_and_process(false)


func _on_reset_pressed() -> void:
	pass


func _on_close_pressed() -> void:
	toggle_visibility()


func _on_run_pressed() -> void:
	pass


# -------------------------
# Helper Functions
# -------------------------

func toggle_visibility() -> void:
	_set_visibility_and_process(!is_visible_console)


func _set_visibility_and_process(value: bool) -> void:
	is_visible_console = value
	visible = value
	set_process(value)
