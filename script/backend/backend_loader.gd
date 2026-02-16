extends Node

const SERVER_URL = "http://127.0.0.1:8000"
const MAX_RETRIES = 20

static var _global_server_pid: int = 0

signal server_ready
signal server_failed

func _ready() -> void:
	_start_server()

func _get_server_path() -> String:
	if OS.has_feature("editor"):
		return ProjectSettings.globalize_path("res://") + "backend/dist/server.exe"
	else:
		return OS.get_executable_path().get_base_dir() + "/server/server.exe"

func _kill_by_port() -> void:
	if OS.get_name() == "Windows":
		OS.execute("cmd.exe", ["/c", "for /f \"tokens=5\" %a in ('netstat -aon ^| findstr :8000 ^| findstr LISTENING') do taskkill /F /PID %a"])
		await get_tree().create_timer(0.5).timeout
	elif _global_server_pid > 0:
		OS.kill(_global_server_pid)
		await get_tree().create_timer(0.3).timeout

func _kill_existing_server() -> void:
	print("Checking for existing server on port 8000...")
	await _kill_by_port()
	_global_server_pid = 0

func _start_server() -> void:
	await _kill_existing_server()

	if _global_server_pid > 0:
		push_warning("Server already launched (PID: %d), skipping." % _global_server_pid)
		await _wait_for_server()
		return

	print("_start_server called from node: ", get_path())

	var server_path = _get_server_path()
	print("Server path: ", server_path)

	if not FileAccess.file_exists(server_path):
		push_error("Server not found at: " + server_path)
		server_failed.emit()
		return

	_global_server_pid = OS.create_process(server_path, [])
	if _global_server_pid <= 0:
		push_error("Failed to launch server process")
		server_failed.emit()
		return

	print("Server process started with PID: ", _global_server_pid)
	await get_tree().create_timer(1.0).timeout
	await _wait_for_server()

func _wait_for_server() -> void:
	for attempt in range(1, MAX_RETRIES + 1):
		print("Health check attempt %d/%d..." % [attempt, MAX_RETRIES])
		if await _ping_server():
			print("Server is ready!")
			server_ready.emit()
			return
		await get_tree().create_timer(0.5).timeout

	push_error("Server did not become ready after %d attempts" % MAX_RETRIES)
	server_failed.emit()

func _ping_server() -> bool:
	var client := HTTPClient.new()
	var err = client.connect_to_host("127.0.0.1", 8000)
	if err != OK:
		return false

	var timeout := 0
	while (client.get_status() == HTTPClient.STATUS_CONNECTING or \
		   client.get_status() == HTTPClient.STATUS_RESOLVING) and timeout < 20:
		client.poll()
		await get_tree().create_timer(0.1).timeout
		timeout += 1

	if client.get_status() != HTTPClient.STATUS_CONNECTED:
		return false

	err = client.request(HTTPClient.METHOD_GET, "/health", ["Host: 127.0.0.1:8000"])
	if err != OK:
		return false

	timeout = 0
	while client.get_status() == HTTPClient.STATUS_REQUESTING and timeout < 20:
		client.poll()
		await get_tree().create_timer(0.1).timeout
		timeout += 1

	while client.get_status() == HTTPClient.STATUS_BODY and timeout < 20:
		client.poll()
		await get_tree().create_timer(0.1).timeout
		timeout += 1

	if not client.has_response():
		return false

	return client.get_response_code() == 200

func _exit_tree() -> void:
	print("Shutting down server...")
	await _kill_by_port()
	_global_server_pid = 0
	print("Server shut down.")
