extends Control


@onready var game_world = get_tree().root.get_node("GameWorld")
@onready var question_editor = $Panel/ScrollContainer/QuestionEditor
@onready var points_editor = $Panel/PointsEditor
func _get_host_player() -> Node:
	return get_tree().root.get_node("GameWorld/Players/1")

func _on_close_button_pressed() -> void:
	var player = _get_host_player()
	player.state_machine.change_state("idlestate")
	queue_free()


func _on_submit_button_pressed() -> void:
	var player = _get_host_player()
	if question_editor.text == null or points_editor == null:
		return
	game_world.set_question(question_editor.text, points_editor.text)
	player.state_machine.change_state("idlestate")
	queue_free()
