extends Button

var question_maker = preload("res://multiplayer/scene/ui/question_maker.tscn")

func _ready() -> void:
	visible = multiplayer.is_server()
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	var existing = get_parent().get_node_or_null("QuestionMaker")
	if existing:
		return
	var instance = question_maker.instantiate()
	instance.name = "QuestionMaker"
	get_parent().add_child(instance)
	# pause when opening
	_get_host_player().state_machine.change_state("pausestate")

func _get_host_player() -> Node:
	return get_tree().root.get_node("GameWorld/Players/1")
