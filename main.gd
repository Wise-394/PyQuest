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
# --- UI References ---
# =====================================================
@onready var coords: CanvasLayer = $gui/coords
@onready var console: CanvasLayer = $gui/Console
@onready var coords_label: Label = $gui/coords/coordinates
@onready var skills_terminal: CanvasLayer = $gui/skills_terminal

# =====================================================
# --- Scenes / Resources ---
# =====================================================
@export var spawnable_platform: PackedScene = preload("res://scene/spawnable_platform.tscn")
@onready var physics_box_scene: PackedScene = preload("res://scene/spawnable_box.tscn")

# =====================================================
# --- Engine Callbacks ---
# =====================================================
func _ready() -> void:
	var resource = load("res://dialogue/intro.dialogue")
	DialogueManager.show_dialogue_balloon(resource, "start")

	# --- Signal connections ---
	if not DialogueManager.dialogue_started.is_connected(_on_dialogue_started):
		DialogueManager.dialogue_started.connect(_on_dialogue_started)

	if not DialogueManager.dialogue_ended.is_connected(_on_dialogue_ended):
		DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

	if not skills_terminal.skills_terminal_state_changed.is_connected(_on_skills_terminal_state_changed):
		skills_terminal.skills_terminal_state_changed.connect(_on_skills_terminal_state_changed)

	if not console.console_opened.is_connected(_on_console_opened):
		console.console_opened.connect(_on_console_opened)

	if not console.console_closed.is_connected(_on_console_closed):
		console.console_closed.connect(_on_console_closed)


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("open_coords"):
		_toggle_show_coords()
	
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
		lock_coords = not lock_coords
		if lock_coords:
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
	var space_state = get_viewport().get_world_2d().direct_space_state
	var shape: Shape2D = _get_platform_shape()
	if shape == null:
		push_error("No CollisionShape2D found in spawnable_platform.tscn")
		return false
	
	var xform = Transform2D(0, pos)
	var params := PhysicsShapeQueryParameters2D.new()
	params.shape = shape
	params.transform = xform
	params.collision_mask = 0xFFFFFFFF  
	
	var result = space_state.intersect_shape(params)
	return result.size() == 0

func _get_platform_shape() -> Shape2D:
	var platform = spawnable_platform.instantiate()
	for child in platform.get_children():
		if child is CollisionShape2D and child.shape != null:
			return child.shape
	return null

func place_platform(x: int, y: int):
	var pos = Vector2(x, y)
	if can_spawn_new_platform(pos):
		var new_platform = spawnable_platform.instantiate()
		new_platform.global_position = pos   
		get_tree().current_scene.add_child(new_platform)
		return new_platform
	else:
		return null


# =====================================================
# --- Box Spawning Helpers ---
# =====================================================
func can_spawn_new_box(pos: Vector2) -> bool:
	var space_state = get_viewport().get_world_2d().direct_space_state
	var shape: Shape2D = _get_box_shape()
	if shape == null:
		push_error("No CollisionShape2D found in spawnable_box.tscn")
		return false
	
	var xform = Transform2D(0, pos)
	var params := PhysicsShapeQueryParameters2D.new()
	params.shape = shape
	params.transform = xform
	params.collision_mask = 0xFFFFFFFF
	
	var result = space_state.intersect_shape(params)
	print("Box collision check at ", pos, " → result: ", result.size())
	return result.size() == 0

func _get_box_shape() -> Shape2D:
	var box = physics_box_scene.instantiate()
	for child in box.get_children():
		if child is CollisionShape2D and child.shape != null:
			return child.shape
	return null

func place_box(x: int, y: int) -> RigidBody2D:
	var pos = Vector2(x, y)
	if can_spawn_new_box(pos):
		var new_box = physics_box_scene.instantiate()
		new_box.global_position = pos
		get_tree().current_scene.add_child(new_box)
		return new_box
	else:
		print("Could not spawn box at ", pos)
		return null
