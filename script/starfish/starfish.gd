extends Area2D

@onready var label: Label = $Label
@export var dialog: Node
var _isVisible = false
var _isDialogActive = false
var player: CharacterBody2D

func _ready() -> void:
	dialog.dialogue_finished.connect(_on_dialog_finished)
	

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("open_dialog") and _isVisible and not _isDialogActive:
		_open_dialog()
	
			
func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player = body
		_change_visibility()


func _on_body_exited(body: Node2D) -> void:
		if body.name == "Player":
			_change_visibility()

func _change_visibility():
	if _isVisible == true:
		label.visible = false
		_isVisible = false
	else:
		label.visible = true
		_isVisible = true

func _open_dialog():
	_isDialogActive = true
	dialog.open_dialog()
	player.state_machine.change_state("dialogstate")
	
func _on_dialog_finished():
	if player:
		player.state_machine.exit_dialog()
	_isDialogActive = false
