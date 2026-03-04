extends State

var code_editor = preload("res://multiplayer/scene/ui/network_code_editor.tscn")

func enter() -> void:
	init_references()
	sprite.play("idle")
	character.velocity.x = 0
	_spawn_code_editor()

func exit() -> void:
	_remove_code_editor()

func _get_canvas_layer() -> Node:
	return get_tree().root.get_node_or_null("GameWorld/CanvasLayer")

func _spawn_code_editor() -> void:
	var canvas_layer := _get_canvas_layer()
	if canvas_layer == null:
		push_error("CanvasLayer not found!")
		return
	if canvas_layer.has_node("CodeEditor"):
		return
	var instance := code_editor.instantiate()
	instance.player = character
	instance.name = "CodeEditor"
	canvas_layer.add_child(instance)

func _remove_code_editor() -> void:
	var canvas_layer := _get_canvas_layer()
	if canvas_layer == null:
		return
	var editor := canvas_layer.get_node_or_null("CodeEditor")
	if editor:
		editor.queue_free()

func update(delta) -> void:
	character.velocity.y += character.gravity * delta
	character.move_and_slide()

func physics_update(_delta) -> void:
	pass

func handle_input(_event) -> void:
	pass
