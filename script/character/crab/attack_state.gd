extends State
class_name AttackingState


func enter():
	init_references()
	if not sprite.animation_finished.is_connected(_on_animation_finished):
		sprite.animation_finished.connect(_on_animation_finished)
	_play_attack_animation()
	hitbox.monitoring = true
	instantiate_effect()

func exit():
	if sprite.animation_finished.is_connected(_on_animation_finished):
		sprite.animation_finished.disconnect(_on_animation_finished)
	hitbox.monitoring = false

func _play_attack_animation():             
	sprite.play("attack")
	character.velocity.x = 0

func _on_animation_finished() -> void:
	if sprite.animation == "attack":
		character.state_machine.change_state("aggrostate")
	
func instantiate_effect():
	var effect_path = "res://scene/character/crab_attack_effect.tscn"
	
	if not ResourceLoader.exists(effect_path):
		push_warning("Effect scene not found: " + effect_path)
		return
	
	var effect = load(effect_path).instantiate()
	
	# Add to character's parent so it appears in the world
	character.add_child(effect)
	effect.play()
