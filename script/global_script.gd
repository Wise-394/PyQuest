extends Node

# =====================================================
# --- Signals ---
# =====================================================
signal dialogue_opened
signal dialogue_closed
#signal console_opened
#signal console_closed

# =====================================================
# --- State Variables ---
# =====================================================
var is_dialogue_open: bool = false
var is_console_open: bool = false
var show_coords: bool = false   

# =====================================================
# --- UI References ---
# =====================================================
@onready var ui: CanvasLayer   = get_tree().root.get_node("main/UI")
@onready var ui_label: Label = ui.get_node("coordinates")

# =====================================================
# --- Engine Callbacks ---
# =====================================================
func _ready() -> void:
	DialogueManager.dialogue_started.connect(_on_dialogue_started)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("open_coords"):
		_toggle_show_coords()

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
	ui_label.text = "Mouse: " + str(mouse_pos)
	print(ui_label.text)

func _toggle_show_coords() -> void:
	show_coords = !show_coords
	if not show_coords:
		ui_label.text = ""
