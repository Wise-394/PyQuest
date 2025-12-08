extends Node

const BASE_URL: String = "http://127.0.0.1:8000/"

@onready var http_request: HTTPRequest = $HttpRequest
signal get_question_completed
# Tracks which request is currently being processed
var current_request: String = ""


func _ready() -> void:
	http_request.request_completed.connect(_on_request_completed)


# ---------------------------------------------------------------------
# REQUEST COMPLETION HANDLER
# ---------------------------------------------------------------------
func _on_request_completed(result, response_code, _headers, body) -> void:
	current_request = current_request.strip_edges()

	if result != HTTPRequest.Result.RESULT_SUCCESS:
		print("❌ Network error or request failed:", result)
		current_request = ""
		return

	var body_string = body.get_string_from_utf8()
	var json = JSON.parse_string(body_string)

	match current_request:
		"test_connection":
			_handle_test_connection(response_code, json)
			
		"get_question":
			_handle_get_question(response_code, json)
			
		_:
			print("⚠ Unhandled request type:", current_request)

	current_request = "" 


# ---------------------------------------------------------------------
# RESPONSE HANDLERS
# ---------------------------------------------------------------------
func _handle_test_connection(code: int,json) -> void:
	if code == 200:
		print(json["message"])
	else:
		print("❌ Backend offline | Code:", code)


func _handle_get_question(code: int, json) -> void:
	if code != 200:
		print("Failed to fetch question | Code:", code)
		return

	if json is Dictionary and json.has("question"):
		get_question_completed.emit(json["question"])
	else:
		print("nvalid JSON or missing 'question'.")


# ---------------------------------------------------------------------
# API METHODS
# ---------------------------------------------------------------------
func test_connection_api() -> void:
	current_request = "test_connection"
	http_request.request(BASE_URL)

func get_question(id: int) -> void:
	current_request = "get_question"
	http_request.request(BASE_URL + "question/" + str(id))
	
func submit_code(id,code) -> void:
	current_request = "post_question"
	
	
