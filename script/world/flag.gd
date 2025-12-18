extends Area2D

@onready var zone_remaining: Label = get_tree().current_scene.get_node("UI/CanvasLayer/ZoneRemaining")
@onready var coin_label = get_tree().current_scene.get_node("UI/CanvasLayer/CoinContainer")
@export_file("*.tscn") var level_to_go: String

func _on_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		return

	if zone_remaining.get_not_completed_count() <= 0:
		call_deferred("next_level")
	else:
		print("not completed")

func next_level():
	if level_to_go == "":
		push_error("Next level not set!")
		return
	
	save()
	get_tree().change_scene_to_file(level_to_go)
func save():
	var coins_amount = int(coin_label.text)
	SaveLoad.contents.coins = coins_amount
	SaveLoad.save_data()
	
