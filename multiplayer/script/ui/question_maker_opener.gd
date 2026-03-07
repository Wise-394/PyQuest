extends Button

const QUESTION_MAKER := preload("res://multiplayer/scene/ui/question_maker.tscn")
const NEXT_ROUND     := preload("res://multiplayer/scene/ui/next_round.tscn")

func _ready() -> void:
	visible = multiplayer.is_server()
	pressed.connect(_on_pressed)
	var game_world := get_tree().root.get_node("GameWorld")
	game_world.question_updated.connect(_update_button_text)
	_update_button_text()

func _update_button_text() -> void:
	var game_world   := get_tree().root.get_node("GameWorld")
	var has_question  = game_world.question_object["question_string"] != ""
	text              = "Next Round" if has_question else "Make Question"

func _on_pressed() -> void:
	var game_world   := get_tree().root.get_node("GameWorld")
	var has_question  = game_world.question_object["question_string"] != ""
	if has_question:
		_open_next_round()
	else:
		_open_question_maker()

func _open_question_maker() -> void:
	var canvas_layer := get_parent()
	if canvas_layer.has_node("QuestionMaker"):
		return
	var instance := QUESTION_MAKER.instantiate()
	instance.name = "QuestionMaker"
	canvas_layer.add_child(instance)
	_get_host_player().state_machine.change_state("pausestate")

func _open_next_round() -> void:
	var canvas_layer := get_parent()
	if canvas_layer.has_node("NextRound"):
		return
	var instance := NEXT_ROUND.instantiate()
	instance.name = "NextRound"
	canvas_layer.add_child(instance)

func _get_host_player() -> Node:
	return get_tree().root.get_node("GameWorld/Players/1")
