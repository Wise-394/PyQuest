extends Control
var level_to_go: String
var level: int
@onready var coin_label: Label = get_tree().current_scene.get_node_or_null("UI/CanvasLayer/CoinContainer/CoinLabel")

func _on_exit_pressed() -> void:
	save()
	check_achievements()
	AchievementManager.debug_print_unlocked()
	SaveLoad.current_lvl_pts = 0
	SaveLoad.current_level = 0
	get_tree().change_scene_to_file("res://scene/save/loading_screen.tscn")

func _on_restart_pressed() -> void:
	SaveLoad.current_lvl_pts = 0
	get_tree().reload_current_scene()

func _on_next_level_pressed() -> void:
	AchievementManager.debug_print_unlocked()
	call_deferred("next_level")

func save() -> void:
	if coin_label:
		SaveLoad.data["coins"] = int(coin_label.text)
	else:
		push_warning("CoinLabel not found, coins not saved")

	if level_to_go != "":
		level = get_level_number_from_path(level_to_go)

		if level != -1 and SaveLoad.data["highest_unlocked_level"] <= level:
			SaveLoad.data["highest_unlocked_level"] = level

	SaveLoad.current_lvl_pts = 0
	SaveLoad.save_slot()

func check_achievements():
	AchievementManager.on_coins_changed(SaveLoad.data['coins'])
	AchievementManager.on_level_finished(level - 1)
	

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
	check_achievements()
	get_tree().change_scene_to_file(level_to_go)
