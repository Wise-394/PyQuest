extends Node

const BACKEND_URL := "http://127.0.0.1:8000/execute"

@onready var http_request = $HTTPRequest

signal output_received(output: String)
signal request_failed(reason: String)

func _ready() -> void:
	http_request.request_completed.connect(_on_response)

func run_code(code: String) -> void:
	var body    := JSON.stringify({ "code": code })
	var headers := ["Content-Type: application/json"]
	http_request.request(BACKEND_URL, headers, HTTPClient.METHOD_POST, body)

func _on_response(result: int, response_code: int, _headers: Array, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("Request failed, result: %d" % result)
		request_failed.emit("Request failed.")
		return
	if response_code != 200:
		push_error("Server error: %d" % response_code)
		request_failed.emit("Server error: %d" % response_code)
		return
	var json := JSON.new()
	if json.parse(body.get_string_from_utf8()) != OK:
		push_error("Invalid response from server.")
		request_failed.emit("Invalid response.")
		return
	var data: Dictionary = json.get_data()
	output_received.emit(data.get("output", "No output."))
