extends CanvasLayer

# =====================================================
# --- Signals ---
# =====================================================
signal skills_terminal_state_changed

# =====================================================
# --- State Variables ---
# =====================================================
var is_open: bool = false

# =====================================================
# --- UI References ---
# =====================================================
@onready var user_code: TextEdit = $Panel/user_code
@onready var output_label: Label = $Panel/output_label

# =====================================================
# --- Commands ---
# =====================================================
var commands: Dictionary = {}

func _ready() -> void:
	visible = false  
	_register_commands()

# -----------------------------------------------------
# Register available commands
# -----------------------------------------------------
func _register_commands() -> void:
	commands = {
		"place_platform": _cmd_place_platform,
		# Add more commands here later
	}

# =====================================================
# --- Command Handlers ---
# =====================================================
func _cmd_place_platform(args: Array) -> void:
	var placed = null

	match args.size():
		2:
			var x = float(args[0])
			var y = float(args[1])
			placed = GlobalScript.place_platform(x, y)
			_log_spawn_result(placed, Vector2(x, y))

		0:
			var mouse_pos = get_viewport().get_mouse_position()
			placed = GlobalScript.place_platform(mouse_pos.x, mouse_pos.y)
			_log_spawn_result(placed, mouse_pos, true)

		_:
			_print_to_terminal("❌ place_platform requires 0 args (mouse) or 2 args: x, y")

# -----------------------------------------------------
# Helper to format success/failure messages
# -----------------------------------------------------
func _log_spawn_result(placed, pos: Vector2, use_mouse: bool=false) -> void:
	var x_str = str(round(pos.x * 100) / 100.0)
	var y_str = str(round(pos.y * 100) / 100.0)

	if placed:
		if use_mouse:
			_print_to_terminal("✅ Spawned platform at mouse (" + x_str + ", " + y_str + ")")
		else:
			_print_to_terminal("✅ Spawned platform at (" + x_str + ", " + y_str + ")")
	else:
		if use_mouse:
			_print_to_terminal("❌ Failed to spawn platform at mouse (" + x_str + ", " + y_str + ")")
		else:
			_print_to_terminal("❌ Failed to spawn platform at (" + x_str + ", " + y_str + ")")

# =====================================================
# --- Terminal Visibility ---
# =====================================================
func toggle_terminal() -> void:
	if is_open:
		close_terminal()
	else:
		open_terminal()

func open_terminal() -> void:
	visible = true
	is_open = true
	skills_terminal_state_changed.emit("opened")

func close_terminal() -> void:
	visible = false
	is_open = false
	_clean_terminal()
	skills_terminal_state_changed.emit("closed")

# Close button handler
func _on_close_pressed() -> void:
	close_terminal()

# =====================================================
# --- Interpreter ---
# =====================================================
func _on_run_pressed() -> void:
	var code: String = user_code.text.strip_edges()
	if code == "":
		return
	
	if code.find("(") != -1 and code.ends_with(")"):
		var command_name = code.substr(0, code.find("(")).strip_edges()
		var args_str = code.substr(code.find("(") + 1, code.length() - code.find("(") - 2)

		var args: Array = []
		if args_str != "":
			args = args_str.split(",")
			for i in range(args.size()):
				args[i] = _parse_arg(args[i])
		
		# Match command
		if command_name in commands:
			commands[command_name].call(args)
		else:
			_print_to_terminal("❌ Unknown command: " + command_name)
	else:
		_print_to_terminal("❌ Invalid syntax. Example: place_platform(100, 200)")

# =====================================================
# --- Helpers ---
# =====================================================
# Parse numbers properly (int, float, negatives)
func _parse_arg(value: String) -> Variant:
	value = value.strip_edges()
	
	# Try integer
	if value.is_valid_int():
		return int(value)
	
	# Try float
	if value.is_valid_float():
		return float(value)
	
	# Otherwise return raw string
	return value

func _print_to_terminal(msg: String) -> void:
		output_label.text = msg.strip_edges()
		
func _clean_terminal():
	user_code.text = ""
	output_label.text = ""
