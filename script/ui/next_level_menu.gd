extends Control

var level_to_go: String
@onready var coin_label: Label = get_tree().current_scene.get_node_or_null("UI/CanvasLayer/CoinContainer/CoinLabel")
func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/lvl/main_menu.tscn")


func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()



func _on_next_level_pressed() -> void:
	call_deferred("next_level")

func save() -> void:
	if coin_label:
		var coins_amount := int(coin_label.text)
		SaveLoad.contents.coins = coins_amount
	else:
		push_warning("CoinLabel not found, coins not saved")

	SaveLoad.save_data()

func next_level() -> void:
	if level_to_go == "":
		push_error("Next level not set!")
		return
	
	save()
	get_tree().change_scene_to_file(level_to_go)
