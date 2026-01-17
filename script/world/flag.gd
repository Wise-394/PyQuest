extends Area2D

# Nullable UI references
@onready var zone_remaining := get_tree().current_scene.get_node_or_null("UI/CanvasLayer/ZoneRemaining")
@onready var coin_label: Label = get_tree().current_scene.get_node_or_null("UI/CanvasLayer/CoinContainer/CoinLabel")

@export_file("*.tscn") var level_to_go: String

func _on_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		return

	# If ZoneRemaining exists and is NOT completed, block level change
	if zone_remaining and zone_remaining.get_not_completed_count() > 0:
		print("not completed")
		return

	# Either completed OR ZoneRemaining doesn't exist
	call_deferred("next_level")

func next_level() -> void:
	if level_to_go == "":
		push_error("Next level not set!")
		return
	
	save()
	get_tree().change_scene_to_file(level_to_go)

func save() -> void:
	if coin_label:
		var coins_amount := int(coin_label.text)
		SaveLoad.contents.coins = coins_amount
	else:
		push_warning("CoinLabel not found, coins not saved")

	SaveLoad.save_data()
