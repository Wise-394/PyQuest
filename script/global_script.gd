extends Node

# =====================================================
# --- Signals ---
# =====================================================
signal dialogue_opened
signal dialogue_closed
signal skills_terminal_state_changed_global

# =====================================================
# --- State Variables ---
# =====================================================
var is_dialogue_open: bool = false
var show_coords: bool = false   
var is_skills_terminal_open: bool = false
var is_console_open: bool = false
var lock_coords: bool = false  

# =====================================================
# --- UI References {set on main}---
# =====================================================
var coords: CanvasLayer
var console: CanvasLayer
var coords_label: Label
var skills_terminal: CanvasLayer

# =====================================================
# --- Scenes / Resources ---
# =====================================================
@export var spawnable_platform: PackedScene = preload("res://scene/spawnable_platform.tscn")

# =====================================================
# --- Engine Callbacks ---
# =====================================================
func _ready() -> void:
	pass


func _unhandled_key_input(event: InputEvent) -> void:
	# Toggle showing coordinates
	if event.is_action_pressed("open_coords"):
		_toggle_show_coords()
	
	# Toggle skills terminal (only if no dialogue or console is open)
	if (event.is_action_pressed("open_one_line_terminal")
	and not is_dialogue_open
	and not is_console_open):
		skills_terminal.toggle_terminal()
		is_skills_terminal_open = skills_terminal.is_open


func _input(event: InputEvent) -> void:
	if show_coords and not lock_coords and event is InputEventMouseMotion:
		_update_mouse_coordinates()


func _unhandled_input(event: InputEvent) -> void:
	if show_coords and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if lock_coords:
			lock_coords = false
		else:
			lock_coords = true
			_update_mouse_coordinates()
# =====================================================
# --- Dialogue Handlers ---
# =====================================================
func _on_dialogue_started(_res) -> void:
	is_dialogue_open = true
	dialogue_opened.emit()


func _on_dialogue_ended(_res) -> void:
	is_dialogue_open = false
	dialogue_closed.emit()


# =====================================================
# --- Coordinate Display Helpers ---
# =====================================================
# =====================================================
# --- Coordinate Display Helpers ---
# =====================================================
func _update_mouse_coordinates() -> void:
	var camera := get_viewport().get_camera_2d()
	if camera:
		var world_mouse_pos: Vector2 = camera.get_global_mouse_position()
		var rounded_pos := Vector2(
			round(world_mouse_pos.x * 100) / 100.0,
			round(world_mouse_pos.y * 100) / 100.0
		)
		coords_label.text = "Coords: " + str(rounded_pos)


func _toggle_show_coords() -> void:
	show_coords = !show_coords
	lock_coords = false
	if show_coords:
		Input.set_default_cursor_shape(Input.CURSOR_CROSS)
		_update_mouse_coordinates()
	else:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
		coords_label.text = ""


# =====================================================
# --- Skills Terminal Handlers ---
# =====================================================
func _on_skills_terminal_state_changed(state: String) -> void:
	if state == "opened":
		skills_terminal_state_changed_global.emit("opened")
	else:
		skills_terminal_state_changed_global.emit("closed")


# =====================================================
# --- Console Handlers ---
# =====================================================
func _on_console_opened() -> void:
	is_console_open = true


func _on_console_closed(_caller_id) -> void:
	is_console_open = false


# =====================================================
# --- Platform Spawning Helpers ---
# =====================================================
func can_spawn_new_platform(pos: Vector2) -> bool:
	"""
	Check if a new platform can be spawned at the given world position.
	Returns true if no collision detected.
	"""
	var space_state = get_viewport().get_world_2d().direct_space_state
	
	# Get platform shape (CollisionShape2D from scene)
	var shape: Shape2D = _get_platform_shape()
	if shape == null:
		push_error("No CollisionShape2D found in spawnable_platform.tscn")
		return false
	
	# Build transform for the query
	var xform = Transform2D(0, pos)
	
	# Setup query parameters
	var params := PhysicsShapeQueryParameters2D.new()
	params.shape = shape
	params.transform = xform
	params.collision_mask = 0xFFFFFFFF  # check against everything
	
	# Run collision check
	var result = space_state.intersect_shape(params)
	return result.size() == 0


func _get_platform_shape() -> Shape2D:
	"""
	Helper: Extracts the first CollisionShape2D's Shape2D from the spawnable_platform scene.
	"""
	var platform = spawnable_platform.instantiate()
	for child in platform.get_children():
		if child is CollisionShape2D:
			return child.shape
	return null


func place_platform(x: int, y: int):
	"""
	Attempts to place a platform at (x, y).
	Returns the new platform instance if successful, null otherwise.
	"""
	var pos = Vector2(x, y)
	
	if can_spawn_new_platform(pos):
		var new_platform = spawnable_platform.instantiate()
		new_platform.global_position = pos   
		get_tree().current_scene.add_child(new_platform)
		return new_platform
	else:
		return null
