extends Control

@onready var game_world     = get_tree().root.get_node("GameWorld")
@onready var question_label = $Panel/ScrollContainer2/QuestionLabel
@onready var output_label   = $Panel/ScrollContainer3/OutputLabel
@onready var code_input     = $Panel/ScrollContainer/CodeEdit
@onready var code_runner    = $CodeRunner

var player

func _ready() -> void:
	question_label.text = game_world.question_object["question_string"]
	code_runner.output_received.connect(_on_output_received)
	code_runner.request_failed.connect(_on_request_failed)

func _on_close_button_pressed() -> void:
	player.state_machine.change_state("idlestate")

func _on_run_button_pressed() -> void:
	output_label.text = "Running..."
	code_runner.run_code(code_input.text)

func _on_output_received(output: String) -> void:
	output_label.text = output

func _on_request_failed(reason: String) -> void:
	output_label.text = reason
