# CodeExecutionService.gd
extends Node

# =====================================================
# --- Configuration ---
# =====================================================
const API_ENDPOINT = "execute_code/"
const HEADERS = ["Content-Type: application/json"]
const REQUEST_METHOD = HTTPClient.METHOD_POST

# =====================================================
# --- Public API ---
# =====================================================
## Sends user code to the backend for execution.
func send_code_to_server(user_code: String) -> int:
	var json_body = JSON.stringify({"code": user_code})
	
	# This line calls the `make_request` function in the parent script (`BackendAPI.gd`)
	# to actually send the request.
	return get_parent().make_request(API_ENDPOINT, HEADERS, REQUEST_METHOD, json_body)
