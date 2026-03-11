extends Control

signal chest_closed(is_correct: bool)

@onready var question_label: Label = $Panel/ScrollContainer/question
@onready var answer_input: LineEdit = $Panel/answer

var correct_answers: Array[String]

func open_chest_ui(chest_question: String, chest_answers: Array[String]) -> void:
	question_label.text = chest_question
	correct_answers = chest_answers

func _on_close_pressed() -> void:
	var is_correct = _is_answer_correct(answer_input.text)
	chest_closed.emit(is_correct)
	call_deferred("queue_free")

func _on_submit_pressed() -> void:
	if _is_answer_correct(answer_input.text):
		var instance = preload("res://scene/world/confetti_effect.tscn").instantiate()
		get_tree().current_scene.get_node("UI/CanvasLayer").add_child(instance)
		instance.position = get_viewport().get_visible_rect().size / 2
		instance.emitting = true

func _is_answer_correct(answer_text: String) -> bool:
	var lower_input = answer_text.to_lower().strip_edges()
	return correct_answers.any(func(a): return a.to_lower().strip_edges() == lower_input)
