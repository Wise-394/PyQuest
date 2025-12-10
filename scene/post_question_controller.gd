extends Node

@export var child_nodes: Array[Node]
@onready var code_editor: Control = get_tree().current_scene.get_node("UI/CanvasLayer/CodeEditor")

func _ready() -> void:
	code_editor.code_editor_closed.connect(activate_child)
	
func activate_child(is_correct,id):
	if(is_correct):
		for child in child_nodes:
			if child and child.has_method("activate") and child.id == id:
				child.activate()
