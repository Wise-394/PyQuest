extends Control

@onready var game_world = get_tree().root.get_node("GameWorld")
@onready var question_label = $Panel/ScrollContainer2/QuestionLabel

func _ready() -> void:
	question_label.text = game_world.question_object["question_string"]
var player
func _on_close_button_pressed() -> void:
	player.state_machine.change_state("idlestate")
