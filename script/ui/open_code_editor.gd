#this node is responsible for opening and closing of code editor,
#changing state to on_code_edit
extends Area2D

@onready var label: Label = $Label
@onready var player: CharacterBody2D = get_tree().current_scene.get_node("Player")
@onready var code_editor: Control = get_tree().current_scene.get_node("UI/CanvasLayer/CodeEditor")

var is_label_visible := false


func _ready() -> void:
	label.visible = false
	set_process(false)
	print(player, code_editor, label)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("open_console") and is_label_visible:
		open_console()


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		_set_visibility(true)


func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		_set_visibility(false)


# -----------------------
#   Helper Functions
# -----------------------

func _set_visibility(value: bool) -> void:
	is_label_visible = value
	label.visible = value
	set_process(value)


func open_console() -> void:
	code_editor.toggle_visibility()
