extends Control

@onready var reset_button = $Panel/MarginContainer/VBoxContainer/Header/Reset
@onready var close_button = $Panel/MarginContainer/VBoxContainer/Header/Close
@onready var run_button = $Panel/MarginContainer/VBoxContainer/Run
@onready var Code_edit = $Panel/MarginContainer/VBoxContainer/CodeContainer/CodeEdit
@onready var question_label = $Panel/MarginContainer/VBoxContainer/QuestionContainer/QuestionLabel
@onready var output_label = $Panel/MarginContainer/VBoxContainer/OutputContainer/OutputLabel
var isVisible = false

func _ready() -> void:
	#visible = false
	pass

func _on_reset_pressed() -> void:
	pass # Replace with function body.


func _on_close_pressed() -> void:
	#toggle_visibility()
	pass


func _on_run_pressed() -> void:
	pass # Replace with function body.


func toggle_visibility():
	if isVisible:
		visible = false
		isVisible = false
	else:
		visible = true
		isVisible = true
