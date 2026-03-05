extends Control

# ─── Node References ─────────────────────────────────────
@onready var code_edit      := $HostCodeEditorPanel/ScrollContainer/CodeEdit
@onready var question_label : Label = $HostCodeEditorPanel/ScrollContainer2/QuestionLabel
@onready var output_label   : Label = $HostCodeEditorPanel/ScrollContainer3/OutputLabel
@onready var code_runner    : Node  = $CodeRunner
@onready var points_slider  : HSlider = $CheckPanel/Points
@onready var correct_button : Button  = $CheckPanel/CorrectButton
@onready var wrong_button   : Button  = $CheckPanel/WrongButton
@onready var points_label   : Label   = $CheckPanel/PointsLabel
@onready var info_label := $CheckPanel/InfoLabel
# ─── State ───────────────────────────────────────────────
var player_id   : int
var player_code : String
var is_correct  : bool = false

# ─── Lifecycle ───────────────────────────────────────────
func _ready() -> void:
	var game_world  = get_tree().root.get_node("GameWorld")
	code_runner.output_received.connect(_on_output_received)
	code_runner.request_failed.connect(_on_request_failed)
	code_edit.text       = player_code
	question_label.text  = game_world.question_object["question_string"]
	var max_points       := int(game_world.question_object["completion_points"])
	points_slider.max_value = max_points
	points_slider.value     = max_points
	points_slider.visible   = false
	points_label.visible = false
	info_label.visible = false
	points_slider.value_changed.connect(_on_points_changed)
	points_label.text = str(int(points_slider.value))

# ─── Setup ───────────────────────────────────────────────
func setup(id: int, code: String) -> void:
	player_id   = id
	player_code = code


# ─── Check Panel ─────────────────────────────────────────
func _on_correct_button_pressed() -> void:
	is_correct            = true
	points_slider.visible = true
	correct_button.modulate = Color.GREEN
	wrong_button.modulate   = Color.WHITE
	points_label.visible = true
	info_label.visible = true

func _on_wrong_button_pressed() -> void:
	is_correct            = false
	points_slider.visible = false
	correct_button.modulate = Color.WHITE
	wrong_button.modulate   = Color.RED
	points_label.visible = false
	info_label.visible = false

func _on_points_changed(value: float) -> void:
	points_label.text = str(int(value))

func _on_submit_button_pressed() -> void:
	if is_correct:
		pass
	else:
		pass
	queue_free()

# ─── Code Runner ─────────────────────────────────────────
func _on_run_button_pressed() -> void:
	output_label.text = "Running..."
	code_runner.run_code(code_edit.text)

func _on_output_received(output: String) -> void:
	output_label.text = output

func _on_request_failed(reason: String) -> void:
	output_label.text = reason

# ─── Close ───────────────────────────────────────────────
func _on_close_button_pressed() -> void:
	queue_free()
