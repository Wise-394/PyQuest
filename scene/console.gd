extends CanvasLayer

# =====================================================
# --- Signals ---
# =====================================================
signal console_opened
signal console_closed
signal user_code_correct 

# =====================================================
# --- Variable ---
# =====================================================
const defaultText = "print hello world"
var caller_id: int = 0 # the id of the one opened the console
#so we can now what opened the console and where to fire the signal
# =====================================================
# --- Nodes ---
# =====================================================
@onready var code_editor: CodeEdit = $Panel/CodeEdit
@onready var code_output_label: RichTextLabel = $Panel/code_output_label
@onready var backend_client: Node = $"../backend"
@onready var guide_label = $Panel/guide_label
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
func open_console(id: int) -> void:
	visible = true
	caller_id = id
	console_opened.emit()

func close_console() -> void:
	visible = false
	code_editor.text = ""
	code_output_label.text = ""
	guide_label.text = defaultText
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
	var status: String = response_data.get("status", "unknown")

	match status:
		"success":
			var output: String = response_data.get("output", "")
			code_output_label.text = output
			guide_label.text = str(is_user_Code_correct(output, "hello world"))
			user_code_correct.emit(caller_id) 
		"error":
			var message: String = response_data.get("message", "Unknown error")
			code_output_label.text = message
		_:
			code_output_label.text = "An unknown error occurred."
			
# =====================================================
# --- Code Checker ---
# =====================================================

func is_user_Code_correct(user_output: String, desired_output: String) -> bool:
	var clean_user = user_output.strip_edges().to_lower()
	var clean_desired = desired_output.strip_edges().to_lower()
	return clean_user == clean_desired
