extends State

const HITBOX_ACTIVE_FRAMES := [2, 3]

func enter():
	init_references()
	if not sprite.animation_finished.is_connected(_animation_finished):
		sprite.animation_finished.connect(_animation_finished)
	if not sprite.frame_changed.is_connected(_on_frame_changed):
		sprite.frame_changed.connect(_on_frame_changed)
	character.sword_hitbox.reset()
	sprite.play("attack")

func exit():
	if sprite.animation_finished.is_connected(_animation_finished):
		sprite.animation_finished.disconnect(_animation_finished)
	if sprite.frame_changed.is_connected(_on_frame_changed):
		sprite.frame_changed.disconnect(_on_frame_changed)
	character.sword_hitbox.deactivate()

func _on_frame_changed():
	var frame := sprite.frame
	if frame == HITBOX_ACTIVE_FRAMES[0]:
		character.sword_hitbox.activate()
	elif frame == HITBOX_ACTIVE_FRAMES[-1] + 1:
		character.sword_hitbox.deactivate()

func _animation_finished():
	state_machine.change_state("idlestate")
