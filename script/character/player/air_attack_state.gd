extends State

# -----------------------------
# VARIABLES
# -----------------------------
const JUMP_ATTACK := "air_attacking"

# -----------------------------
# ENTER STATE
# -----------------------------
func enter():
	init_references()
	hitbox.monitoring = true
	character.velocity.x = 0
	
	if not sprite.animation_finished.is_connected(_on_attack_finished):
		sprite.animation_finished.connect(_on_attack_finished)

	sprite.play(JUMP_ATTACK)
	instantiate_effects()

# -----------------------------
# PHYSICS UPDATE
# -----------------------------
func physics_update(delta):
	# Apply gravity (important for jump attack)
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
	if sprite.animation == JUMP_ATTACK:
		_check_floor_state()

func _check_floor_state():
	if character.is_on_floor():
		state_machine.change_state("idlestate")
	else:
		state_machine.change_state("fallingstate")

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
	
	var direction = 1 if character.visuals.scale.x > 0 else -1
	sword_effect.position = Vector2(30 * direction, 0)
	sword_effect.scale.x = direction
	
	var effect_sprite = _get_effect_sprite(sword_effect)
	if effect_sprite:
		effect_sprite.play(JUMP_ATTACK)

func _get_effect_sprite(effect: Node) -> AnimatedSprite2D:
	if effect is AnimatedSprite2D:
		return effect
	elif effect.has_node("AnimatedSprite2D"):
		return effect.get_node("AnimatedSprite2D")
	
	push_warning("Could not find AnimatedSprite2D in sword effect")
	return null
