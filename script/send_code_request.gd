extends HTTPRequest  # THIS IS KEY

# --- Constants ---
const API_URL = "http://127.0.0.1:8000/execute_code/"
const HEADERS = ["Content-Type: application/json"]
const REQUEST_METHOD = HTTPClient.METHOD_POST
const TIMEOUT_SECONDS = 10

# --- Variables ---
var request_start_time := 0
var _is_request_active := false

func _ready() -> void:
	# connect built-in HTTPRequest signal to our handler
	request_completed.connect(_on_request_completed)

func _process(_delta: float) -> void:
	if _is_request_active:
		var elapsed_seconds = (Time.get_ticks_msec() - request_start_time) / 1000.0
		if elapsed_seconds > TIMEOUT_SECONDS:
			_abort_request("Timeout: The server did not respond in time.")

func send_code_to_server(user_code: String) -> void:
	if _is_request_active:
		print("❌ A request is already in progress. Please wait.")
		return
	
	_is_request_active = true
	request_start_time = Time.get_ticks_msec()
	
	var json_body = JSON.stringify({"code": user_code})
	var error = request(API_URL, HEADERS, REQUEST_METHOD, json_body)  # call directly

	if error != OK:
		_abort_request("Failed to send request.", error)
	else:
		print("✅ Request sent to:", API_URL)

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
		# forward to parent if needed
		if get_parent() and get_parent().has_method("on_send_code_response"):
			get_parent().on_send_code_response(response_json)
	else:
		_handle_request_error("Invalid JSON response: " + response_text)

func _handle_request_error(message: String, code := -1) -> void:
	print("❌", message, " (code:", code, ")")
	if get_parent() and get_parent().has_method("on_send_code_response"):
		get_parent().on_send_code_response({
			"status": "error",
			"message": message,
			"code": code
		})

func _abort_request(message: String, code := -1) -> void:
	if _is_request_active:
		cancel_request()
		_is_request_active = false
		_handle_request_error(message, code)
