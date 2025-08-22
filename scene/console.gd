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
var caller_id: int = 0                     
var desired_output: String = ""            
var current_question_data: Dictionary = {} 
var _question_loaded: bool = false         
var _current_question_id: int = -1         
var _answered_correctly: bool = false      

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
	if _current_question_id == question_id and _question_loaded:
		visible = true
		console_opened.emit()
		return

	visible = true
	caller_id = question_id
	_current_question_id = question_id
	_answered_correctly = false
	code_editor.text = ""
	code_output_label.text = ""
	guide_label.text = "Loading question..."
	_question_loaded = false
	console_opened.emit()

	if is_instance_valid(backend_client):
		backend_client.get_question_from_server(question_id)
	else:
		guide_label.text = "Error: Backend client not found!"
		push_error("Cannot fetch question. BackendClient node is not valid.")

func close_console() -> void:
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
			current_question_data = response_data
			desired_output = response_data.get("desired_output", "")

			var question_text: String = response_data.get("question", "Unknown question")
			var question_id: int = response_data.get("id", 0)
			guide_label.text = question_text

			_question_loaded = true

		"success":
			var output: String = response_data.get("output", "")
			code_output_label.text = output

			if desired_output != "" and not _answered_correctly and is_user_code_correct(output, desired_output):
				user_code_correct.emit(caller_id)
				_answered_correctly = true
				var explanation: String = current_question_data.get("explanation", "")
				# overwrite guide label with explanation only
				guide_label.text = "✅ Correct!\nExplanation:\n%s" % explanation

		"error":
			var message: String = response_data.get("message", "Unknown error")
			code_output_label.text = message

		_:
			code_output_label.text = "An unknown error occurred."

# =====================================================
# --- Code Checker ---
# =====================================================
func is_user_code_correct(user_output: String, desired_output: String) -> bool:
	var clean_user = user_output.strip_edges().to_lower()
	var clean_desired = desired_output.strip_edges().to_lower()
	return clean_user == clean_desired
