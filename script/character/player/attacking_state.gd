extends State
class_name AttackingState

# -----------------------------
# VARIABLES
# -----------------------------
var attack_animations := ["attacking1", "attacking2", "attacking3"]
var current_attack: String = ""

# -----------------------------
# ENTER STATE
# -----------------------------
func enter():
	init_references()
	hitbox.monitoring = true
	character.velocity = Vector2.ZERO
	
	if not sprite.animation_finished.is_connected(_on_attack_finished):
		sprite.animation_finished.connect(_on_attack_finished)
	
	current_attack = attack_animations.pick_random()
	sprite.play(current_attack)
	instantiate_effects()

# -----------------------------
# PHYSICS UPDATE
# -----------------------------
func physics_update(delta):
	if not character.is_on_floor():
		character.velocity.y += character.gravity * delta
	
	character.velocity.x = 0
	character.move_and_slide()

# -----------------------------
# EXIT STATE
# -----------------------------
func exit():
	hitbox.monitoring = false
	
	if sprite.animation_finished.is_connected(_on_attack_finished):
		sprite.animation_finished.disconnect(_on_attack_finished)

# -----------------------------
# CALLBACKS
# -----------------------------
func _on_attack_finished():
	if not current_attack.is_empty() and sprite.animation == current_attack:
		_check_floor_state()

func _check_floor_state():
	if not character.is_on_floor():
		state_machine.change_state("fallingstate")
	else:
		state_machine.change_state("idlestate")

# -----------------------------
# EFFECTS
# -----------------------------
func instantiate_effects():
	var effect_path = "res://scene/character/sword_effect.tscn"
	
	if not ResourceLoader.exists(effect_path):
		push_warning("Effect scene not found: " + effect_path)
		return
	
	var sword_effect = load(effect_path).instantiate()
	character.add_child(sword_effect)
	
	# Position relative to character
	var direction = -1 if sprite.flip_h else 1
	var offset = Vector2(30 * direction, 0)
	sword_effect.position = offset
	sword_effect.scale.x = direction
	
	# Play matching animation
	var effect_sprite = _get_effect_sprite(sword_effect)
	if effect_sprite:
		effect_sprite.play(current_attack)

func _get_effect_sprite(effect: Node) -> AnimatedSprite2D:
	if effect is AnimatedSprite2D:
		return effect
	elif effect.has_node("AnimatedSprite2D"):
		return effect.get_node("AnimatedSprite2D")
	
	push_warning("Could not find AnimatedSprite2D in sword effect")
	return null
