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
var is_skills_terminal_open = false
# =====================================================
# --- UI References ---
# =====================================================
@onready var coords: CanvasLayer = get_tree().root.get_node("main/gui/coords")
@onready var coords_label: Label = coords.get_node("coordinates")
@onready var skills_terminal: CanvasLayer = get_tree().root.get_node("main/gui/skills_terminal")

# =====================================================
# --- Engine Callbacks ---
# =====================================================
func _ready() -> void:
	DialogueManager.dialogue_started.connect(_on_dialogue_started)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	skills_terminal.skills_terminal_state_changed.connect(_on_skills_terminal_state_changed)
func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("open_coords"):
		_toggle_show_coords()
	if event.is_action_pressed("open_one_line_terminal") and not is_dialogue_open:
		skills_terminal.toggle_terminal()
		is_skills_terminal_open = skills_terminal.is_open

func _input(event: InputEvent) -> void:
	if show_coords and event is InputEventMouseMotion:
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
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	coords_label.text = "Coords: " + str(mouse_pos)

func _toggle_show_coords() -> void:
	show_coords = !show_coords
	if not show_coords:
		coords_label.text = ""
# =====================================================
# --- skills terminal Helpers ---
# =====================================================
func _on_skills_terminal_state_changed(state):
	if state == "opened":
		skills_terminal_state_changed_global.emit("opened")
	else:
		skills_terminal_state_changed_global.emit("closed")
