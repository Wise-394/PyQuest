extends Panel

@export var id: int  # slot index this panel represents (0 - 3)

@onready var title_label  : Label   = $TitleLabel
@onready var level_label  : Label   = $LevelLabel
@onready var account_menu : Control = $"../.."

const LEVEL_SELECTION = preload("res://scene/ui/level_selection.tscn")
const PASSCCODE_WINDOW = preload("res://scene/ui/pass_code_window.tscn")

func _ready() -> void:
	refresh()


func refresh() -> void:
	var slots : Array      = SaveLoad.get_all_slots()
	var slot  : Dictionary = slots[id]

	if slot["exists"]:
		title_label.text = slot["player_name"]
		level_label.text = "Level %d" % slot["highest_unlocked_level"]
	else:
		title_label.text = "No Save File"
		level_label.text = ""


func show_menu() -> void:
	refresh()
	account_menu.visible = true

func is_passcode_null():
	if SaveLoad.data['passcode'] == null or SaveLoad.data['passcode'] == '':
		return true

func show_passcode_window():
	var canvas_layer    = get_tree().current_scene.get_node("CanvasLayer")
	var instance = PASSCCODE_WINDOW.instantiate()
	instance.correct_passcode.connect(go_to_level_selection)
	canvas_layer.add_child(instance)
	
func go_to_level_selection():
	var canvas_layer    = get_tree().current_scene.get_node("CanvasLayer")
	var level_selection = LEVEL_SELECTION.instantiate()
	level_selection.back_pressed.connect(show_menu)
	account_menu.toggle_visibility()
	canvas_layer.add_child(level_selection)
	
func _on_play_button_pressed() -> void:
	if not SaveLoad.load_slot(id):
		SaveLoad.new_slot(id, "Player")
	
	if is_passcode_null():
		go_to_level_selection()
	else:
		show_passcode_window()
