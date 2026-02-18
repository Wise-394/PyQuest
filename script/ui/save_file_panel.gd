extends Panel

@export var id: int  # slot index this panel represents (0 - 3)

@onready var title_label  : Label   = $TitleLabel
@onready var level_label  : Label   = $LevelLabel
@onready var account_menu : Control = $"../.."

const LEVEL_SELECTION = preload("res://scene/ui/level_selection.tscn")


func _ready() -> void:
	_refresh()


func _refresh() -> void:
	var slots : Array      = SaveLoad.get_all_slots()
	var slot  : Dictionary = slots[id]

	if slot["exists"]:
		title_label.text = slot["player_name"]
		level_label.text = "Level %d" % slot["highest_unlocked_level"]
	else:
		title_label.text = "No Save File"
		level_label.text = ""


func show_menu() -> void:
	account_menu.visible = true


func _on_play_button_pressed() -> void:
	if not SaveLoad.load_slot(id):
		SaveLoad.new_slot(id, "Player")

	title_label.text = SaveLoad.data["player_name"]
	level_label.text = "Level %d" % SaveLoad.data["current_level"]

	var canvas_layer    = get_tree().current_scene.get_node("CanvasLayer")
	var level_selection = LEVEL_SELECTION.instantiate()
	level_selection.back_pressed.connect(show_menu)
	account_menu.toggle_visibility()
	canvas_layer.add_child(level_selection)
