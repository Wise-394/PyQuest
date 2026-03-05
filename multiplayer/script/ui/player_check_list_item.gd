extends HBoxContainer

# ─── Constants ───────────────────────────────────────────
const HOST_CODE_EDITOR := preload("res://multiplayer/scene/ui/host_code_editor.tscn")

# ─── Node References ─────────────────────────────────────
@onready var label        : Label  = $Label
@onready var check_button : Button = $CheckButton

# ─── State ───────────────────────────────────────────────
var player_id   : int
var player_code : String

# ─── Setup ───────────────────────────────────────────────
func setup(id: int, code: String) -> void:
	player_id   = id
	player_code = code
	label.text  = "Player %d" % id

# ─── Callbacks ───────────────────────────────────────────
func _on_check_button_pressed() -> void:
	var canvas_layer := get_tree().root.get_node("GameWorld/CanvasLayer")
	if canvas_layer.has_node("HostCodeEditor"):
		return
	var editor := HOST_CODE_EDITOR.instantiate()
	editor.name = "HostCodeEditor"
	editor.setup(player_id, player_code)
	canvas_layer.get_node("PlayerCheckList").visible = false 
	canvas_layer.add_child(editor)
