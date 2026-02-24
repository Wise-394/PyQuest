extends Panel

@export var id: int

@onready var title_label: Label = $TitleLabel
@onready var level_label: Label = $LevelLabel

const PASSCODE_WINDOW = preload("res://scene/ui/pass_code_window.tscn")

func _ready() -> void:
	refresh()

func refresh() -> void:
	var slots: Array = SaveLoad.get_all_slots()
	var slot: Dictionary = slots[id]
	if slot["exists"]:
		title_label.text = slot["player_name"]
		level_label.text = "Level %d" % slot["highest_unlocked_level"]
	else:
		title_label.text = "No Save File"
		level_label.text = ""

func _on_play_button_pressed() -> void:
	if not SaveLoad.load_slot(id):
		SaveLoad.new_slot(id, "Player")

	if _is_passcode_null():
		get_tree().change_scene_to_file("res://scene/ui/level_selection.tscn")
	else:
		get_tree().change_scene_to_file("res://scene/ui/pass_code_window.tscn")

func _is_passcode_null() -> bool:
	return SaveLoad.data['passcode'] == null or SaveLoad.data['passcode'] == ''
