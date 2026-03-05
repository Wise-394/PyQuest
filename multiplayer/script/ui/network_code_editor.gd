extends Control

# ─── Node References ─────────────────────────────────────
@onready var question_label : Label    = $Panel/ScrollContainer2/QuestionLabel
@onready var output_label   : Label    = $Panel/ScrollContainer3/OutputLabel
@onready var code_input     : TextEdit = $Panel/ScrollContainer/CodeEdit
@onready var code_runner    : Node     = $CodeRunner

# ─── State ───────────────────────────────────────────────
var player
@onready var game_world := get_tree().root.get_node("GameWorld")

# ─── Lifecycle ───────────────────────────────────────────
func _ready() -> void:
	question_label.text = game_world.question_object["question_string"]
	code_runner.output_received.connect(_on_output_received)
	code_runner.request_failed.connect(_on_request_failed)

# ─── Callbacks ───────────────────────────────────────────
func _on_close_button_pressed() -> void:
	player.state_machine.change_state("idlestate")

func _on_run_button_pressed() -> void:
	output_label.text = "Running..."
	code_runner.run_code(code_input.text)

func _on_submit_button_pressed() -> void:
	game_world.submit_answer.rpc_id(1, multiplayer.get_unique_id(), code_input.text)
	player.state_machine.change_state("idlestate")

# ─── Code Runner Signals ─────────────────────────────────
func _on_output_received(output: String) -> void:
	output_label.text = output

func _on_request_failed(reason: String) -> void:
	output_label.text = reason
