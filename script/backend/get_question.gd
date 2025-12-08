extends Node

@onready var http_request: HTTPRequest = $HttpRequest
var localhost: String = "http://127.0.0.1:8000/"
func _ready() -> void:
	http_request.request_completed.connect(_on_request_completed)
	
func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	print(json["message"])

func test_connection_api():
	http_request.request(localhost)

func get_question(id):
	http_request.request(localhost+"question/" + str(id))
