extends Area2D


@onready  var player: CharacterBody2D = get_tree().current_scene.get_node("Player")
@onready var code_editor: Control = get_tree().current_scene.get_node("UI/CanvasLayer/CodeEditor")
@onready var label: Label = $Label
var is_label_visible = false

func _ready() -> void:
	label.visible = false
	print(player,code_editor, label)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("open_console") and is_label_visible:
		open_console()

	
func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		toggle_visibility()


func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		toggle_visibility()


func toggle_visibility():
	if is_label_visible:
		label.visible = false
		is_label_visible = false
	else:
		label.visible = true
		is_label_visible = true
	
func open_console():
	code_editor.toggle_visibility()
