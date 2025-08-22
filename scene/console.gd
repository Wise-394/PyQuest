extends CanvasLayer

# =====================================================
# --- Signals ---
# =====================================================
signal console_opened
signal console_closed(caller_id: int)
signal user_code_correct(caller_id: int)

# =====================================================
# --- Variables ---
# =====================================================
var caller_id: int = 0                     # question ID / console owner
var desired_output: String = ""            # expected output
var current_question_data: Dictionary = {} # full question info
var _question_loaded: bool = false         # prevent repeated GET requests
var _current_question_id: int = -1         # track which question is loaded
var _answered_correctly: bool = false      # ensure signal only fires once

# =====================================================
# --- Nodes ---
# =====================================================
@onready var code_editor: CodeEdit = $Panel/CodeEdit
@onready var code_output_label: RichTextLabel = $Panel/code_output_label
@onready var backend_client: Node = $"../backend"
@onready var guide_label: RichTextLabel = $Panel/guide_label

# =====================================================
# --- Lifecycle ---
# =====================================================
func _ready() -> void:
	if is_instance_valid(backend_client):
		backend_client.request_completed.connect(_on_backend_request_completed)
	else:
		push_error("Error: BackendClient node not found! Check path.")

# =====================================================
# --- Public API ---
# =====================================================
func open_console(question_id: int) -> void:
	# Only fetch question if different or not loaded
	if _current_question_id == question_id and _question_loaded:
		visible = true
		console_opened.emit()
		return

	# Reset console state
	visible = true
	caller_id = question_id
	_current_question_id = question_id
	_answered_correctly = false
	code_editor.text = ""
	code_output_label.text = ""
	guide_label.text = "Loading question..."
	_question_loaded = false
	current_question_data.clear()

	console_opened.emit()

	# Request question from backend
	if is_instance_valid(backend_client):
		backend_client.get_question_from_server(question_id)
	else:
		guide_label.text = "Error: Backend client not found!"
		push_error("Cannot fetch question. BackendClient node is not valid.")

func close_console() -> void:
	# Reset console state
	visible = false
	code_editor.text = ""
	code_output_label.text = ""
	guide_label.text = ""
	desired_output = ""
	current_question_data.clear()
	_question_loaded = false
	_current_question_id = -1
	_answered_correctly = false

	console_closed.emit(caller_id)

# =====================================================
# --- UI Callbacks ---
# =====================================================
func _on_send_button_pressed() -> void:
	send_code_to_backend()

func _on_close_button_pressed() -> void:
	close_console()

# =====================================================
# --- Backend Interaction ---
# =====================================================
func send_code_to_backend() -> void:
	var user_code: String = code_editor.text.strip_edges()
	if user_code.is_empty():
		code_output_label.text = "Error: No code to execute."
		return

	code_output_label.text = "Executing code..."

	if is_instance_valid(backend_client):
		backend_client.send_code_to_server(user_code)
	else:
		code_output_label.text = "Error: Backend client is not valid!"
		push_error("Cannot send code. BackendClient node invalid.")

# =====================================================
# --- Backend Response Handling ---
# =====================================================
func _on_backend_request_completed(response_data: Dictionary) -> void:
	var status: String = response_data.get("status", "unknown")

	match status:
		"question":
			_load_question(response_data)

		"success":
			_handle_code_success(response_data)

		"error":
			code_output_label.text = response_data.get("message", "Unknown error")

		_:
			code_output_label.text = "An unknown error occurred."

# =====================================================
# --- Helpers ---
# =====================================================
func _load_question(question_data: Dictionary) -> void:
	current_question_data = question_data
	desired_output = question_data.get("desired_output", "")

	var question_text: String = question_data.get("question", "Unknown question")
	guide_label.text = question_text

	_question_loaded = true

func _handle_code_success(response_data: Dictionary) -> void:
	var output: String = response_data.get("output", "")
	code_output_label.text = output

	if desired_output != "" and not _answered_correctly and is_user_code_correct(output, desired_output):
		_answered_correctly = true
		user_code_correct.emit(caller_id)

		# Overwrite guide label with explanation
		var explanation: String = current_question_data.get("explanation", "")
		guide_label.text = "✅ Correct!\nExplanation:\n%s" % explanation

func is_user_code_correct(user_output: String, desired_output: String) -> bool:
	var clean_user = user_output.strip_edges().to_lower()
	var clean_desired = desired_output.strip_edges().to_lower()
	return clean_user == clean_desired
