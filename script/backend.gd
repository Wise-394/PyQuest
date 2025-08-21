extends Node

# =====================================================
# --- Signals ---
# =====================================================
## Emitted when the server responds (success or error).
signal request_completed(response_data)


# =====================================================
# --- Configuration ---
# =====================================================
const API_URL = "http://127.0.0.1:8000/execute_code/"
const HEADERS = ["Content-Type: application/json"]
const REQUEST_METHOD = HTTPClient.METHOD_POST


# =====================================================
# --- Nodes ---
# =====================================================
@onready var http_request = $HTTPRequest


# =====================================================
# --- Variables ---
# =====================================================
var request_start_time := 0


# =====================================================
# --- Lifecycle ---
# =====================================================
func _ready() -> void:
	# Connect HTTPRequest signal
	http_request.request_completed.connect(_on_request_completed)


# =====================================================
# --- Public API ---
# =====================================================
## Sends user code to the backend for execution.
func send_code_to_server(user_code: String) -> void:
	request_start_time = Time.get_ticks_msec()
	
	var json_body = JSON.stringify({"code": user_code})
	var error = http_request.request(API_URL, HEADERS, REQUEST_METHOD, json_body)

	if error != OK:
		_handle_request_error("Failed to send request.", error)
	else:
		print("✅ Request sent to:", API_URL)


# =====================================================
# --- Private: Response Handling ---
# =====================================================
func _on_request_completed(result, response_code, headers, body) -> void:
	var elapsed = Time.get_ticks_msec() - request_start_time
	print("⏱️ Godot roundtrip took:", elapsed, "ms")

	if response_code == 200:
		_parse_success_response(body)
	else:
		_handle_request_error("Server returned an error. Status code: %d" % response_code)


# =====================================================
# --- Helpers ---
# =====================================================
func _parse_success_response(body: PackedByteArray) -> void:
	var response_text: String = body.get_string_from_utf8()
	var response_json = JSON.parse_string(response_text)

	if response_json is Dictionary:
		emit_signal("request_completed", response_json)
	else:
		_handle_request_error("Invalid JSON response: " + response_text)

func _handle_request_error(message: String, code := -1) -> void:
	print("❌", message, " (code:", code, ")")
	emit_signal("request_completed", {
		"status": "error",
		"message": message,
		"code": code
	})
