extends Node

# =====================================================
# --- Signals ---
# =====================================================
signal request_completed(response_data)

# =====================================================
# --- Configuration ---
# =====================================================
const EXECUTE_CODE_URL = "http://127.0.0.1:8000/execute_code/"
const GET_QUESTION_URL = "http://127.0.0.1:8000/get_question/"  # We'll append the ID
const HEADERS = ["Content-Type: application/json"]
const REQUEST_METHOD_POST = HTTPClient.METHOD_POST
const REQUEST_METHOD_GET = HTTPClient.METHOD_GET
const TIMEOUT_SECONDS = 10

# =====================================================
# --- Nodes ---
# =====================================================
@onready var http_request = $HTTPRequest

# =====================================================
# --- Variables ---
# =====================================================
var request_start_time := 0
var _is_request_active := false

# =====================================================
# --- Lifecycle ---
# =====================================================
func _ready() -> void:
	http_request.request_completed.connect(_on_request_completed)

func _process(_delta: float) -> void:
	if _is_request_active:
		var elapsed_seconds = (Time.get_ticks_msec() - request_start_time) / 1000.0
		if elapsed_seconds > TIMEOUT_SECONDS:
			_abort_request("Timeout: The server did not respond in time.")

# =====================================================
# --- Public API ---
# =====================================================
func send_code_to_server(user_code: String) -> void:
	if _is_request_active:
		print("❌ A request is already in progress. Please wait.")
		return

	_is_request_active = true
	request_start_time = Time.get_ticks_msec()

	var json_body = JSON.stringify({"code": user_code})
	var error = http_request.request(EXECUTE_CODE_URL, HEADERS, REQUEST_METHOD_POST, json_body)

	if error != OK:
		_abort_request("Failed to send request.", error)
	else:
		print("✅ Request sent to:", EXECUTE_CODE_URL)

# New function: get question by ID
func get_question_from_server(question_id: int) -> void:
	if _is_request_active:
		print("❌ A request is already in progress. Please wait.")
		return

	_is_request_active = true
	request_start_time = Time.get_ticks_msec()

	var url = GET_QUESTION_URL + str(question_id)
	var error = http_request.request(url, HEADERS, REQUEST_METHOD_GET, "")

	if error != OK:
		_abort_request("Failed to send get_question request.", error)
	else:
		print("✅ Request sent to:", url)

# =====================================================
# --- Private: Response Handling ---
# =====================================================
func _on_request_completed(result, response_code, headers, body) -> void:
	if not _is_request_active:
		return

	_is_request_active = false
	var elapsed = Time.get_ticks_msec() - request_start_time
	print("⏱️ Godot roundtrip took:", elapsed, "ms")

	if response_code == 200:
		_parse_success_response(body)
	else:
		_handle_request_error("Server returned an error. Status code: %d" % response_code)

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

func _abort_request(message: String, code := -1) -> void:
	if _is_request_active:
		http_request.cancel_request()
		_is_request_active = false
		_handle_request_error(message, code)
