extends CanvasLayer

# =====================================================
# --- Signals ---
# =====================================================
signal console_opened
signal console_closed


# =====================================================
# --- Nodes ---
# =====================================================
@onready var code_editor: CodeEdit = $Panel/CodeEdit
@onready var code_output_label: RichTextLabel = $Panel/code_output_label
@onready var backend_client: Node = $"../backend"

# =====================================================
# --- Lifecycle ---
# =====================================================
func _ready() -> void:
	# Check if the backend client node is valid
	if is_instance_valid(backend_client):
		# Connect BackendClient signal to handle responses
		backend_client.request_completed.connect(_on_backend_request_completed)
	else:
		# Log a critical error and stop further execution if the node is missing
		push_error("Error: BackendClient node not found! Make sure the path is correct.")

# =====================================================
# --- Public API ---
# =====================================================
func open_console() -> void:
	visible = true
	console_opened.emit()

func close_console() -> void:
	visible = false
	console_closed.emit()

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
		push_error("Cannot send code. BackendClient node is not valid.")


# =====================================================
# --- Backend Response Handling ---
# =====================================================
func _on_backend_request_completed(response_data: Dictionary) -> void:
	# Use a more reliable way to get and check the status
	var status: String = response_data.get("status", "unknown")

	match status:
		"success":
			var output: String = response_data.get("output", "")
			code_output_label.text = output
		"error":
			var message: String = response_data.get("message", "Unknown error")
			code_output_label.text = message
		_:
			code_output_label.text = "An unknown error occurred."
