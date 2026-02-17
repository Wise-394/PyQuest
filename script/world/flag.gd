extends Area2D

# Nullable UI references
@onready var zone_remaining := get_tree().current_scene.get_node_or_null("UI/CanvasLayer/ZoneRemaining")
@onready var next_level_menu = preload("res://scene/ui/next_level_menu.tscn")
@onready var canvas_layer = get_tree().current_scene.get_node("UI/CanvasLayer")
@onready var player:= get_tree().current_scene.get_node_or_null("Player")
@export_file("*.tscn") var level_to_go: String

func _on_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		return

	# If ZoneRemaining exists and is NOT completed, block level change
	if zone_remaining and zone_remaining.get_not_completed_count() > 0:
		print("not completed")
		return

	# Either completed OR ZoneRemaining doesn't exist
	call_deferred("show_next_level_menu")

func show_next_level_menu() -> void:
	if level_to_go == "":
		push_error("Next level not set!")
		return
	
	if player == null:
		print("player is null, called from flag.gd")
		return
	
	
	player.state_machine.change_state("pausestate")
	#spawn next level menu
	var instance = next_level_menu.instantiate()
	instance.level_to_go = level_to_go
	canvas_layer.add_child(instance)
	
