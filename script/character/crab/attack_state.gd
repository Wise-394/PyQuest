extends State
class_name AttackingState

func enter():
	init_references()
	if not sprite.animation_finished.is_connected(_on_animation_finished):
		sprite.animation_finished.connect(_on_animation_finished)
	_play_attack_animation()

func exit():
	# CRITICAL: Disconnect signal when leaving state
	if sprite.animation_finished.is_connected(_on_animation_finished):
		sprite.animation_finished.disconnect(_on_animation_finished)

func _play_attack_animation():             
	sprite.play("attack")
	character.velocity.x = 0

func _on_animation_finished() -> void:
	if sprite.animation == "attack":
		character.state_machine.change_state("aggrostate")
