extends Control
var level_to_go: String
var level: int
@onready var coin_label: Label = get_tree().current_scene.get_node_or_null("UI/CanvasLayer/CoinContainer/CoinLabel")

func _on_exit_pressed() -> void:
	save()
	get_tree().change_scene_to_file("res://scene/lvl/main_menu.tscn")

func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()

func _on_next_level_pressed() -> void:
	call_deferred("next_level")

func save() -> void:
	if coin_label:
		SaveLoad.data["coins"] = int(coin_label.text)
	else:
		push_warning("CoinLabel not found, coins not saved")
	level = get_level_number_from_path(level_to_go)
	SaveLoad.data["highest_unlocked_level"] = level
	SaveLoad.save_slot()
	print(level)
	print(SaveLoad.data["highest_unlocked_level"])

func get_level_number_from_path(path: String) -> int:
	var real_path = path
	if path.begins_with("uid://"):
		real_path = ResourceUID.get_id_path(ResourceUID.text_to_id(path))
	
	var file_name = real_path.get_file().get_basename()
	var parts = file_name.split("_")
	if parts.size() >= 2 and parts[-1].is_valid_int():
		return parts[-1].to_int()
	push_error("Could not extract level number from: " + path)
	return -1

func next_level() -> void:
	if level_to_go == "":
		push_error("Next level not set!")
		return
	save()
	get_tree().change_scene_to_file(level_to_go)
