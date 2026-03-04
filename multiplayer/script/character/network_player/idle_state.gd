extends State
func enter():
	init_references()
	sprite.play("idle")


func physics_update(_delta):
	_check_floor_state()
	_handle_movement_input()
	_apply_idle_friction()
	character.move_and_slide()


func handle_input(_event):
	if Input.is_action_just_pressed("jump"):
		state_machine.change_state("jumpstate")
	if Input.is_action_just_pressed("move_down") and character.is_on_floor():
		character.position.y += 1
		state_machine.change_state("fallingstate")
	if Input.is_action_just_pressed("toggle_editor") and character.is_question_discovered:
		state_machine.change_state("codestate")

# ============================
#     SUB FUNCTIONS
# ============================


func _check_floor_state():
	if not character.is_on_floor():
		state_machine.change_state("fallingstate")
		return


func _handle_movement_input():
	var direction = Input.get_axis("move_left", "move_right")

	if direction != 0:
		state_machine.change_state("movestate")
		return
	



func _apply_idle_friction():
	character.velocity.x = lerp(character.velocity.x, 0.0, 0.25)
