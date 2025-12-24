extends State
class_name AttackingState

# -----------------------------
#        VARIABLES
# -----------------------------
var attack_animations := ["attacking1", "attacking2"]

# -----------------------------
#        ENTER STATE
# -----------------------------
func enter():
	init_references()
	hitbox.monitoring = false
	character.velocity = Vector2.ZERO
	
	if not sprite.animation_finished.is_connected(_on_attack_finished):
		sprite.animation_finished.connect(_on_attack_finished)
	
	# Play ONE random attack
	var random_attack = attack_animations.pick_random()
	sprite.play(random_attack)

# -----------------------------
#      PHYSICS UPDATE
# -----------------------------
func physics_update(delta):
	if not character.is_on_floor():
		character.velocity.y += character.gravity * delta
	
	character.velocity.x = 0
	character.move_and_slide()

# -----------------------------
#        EXIT STATE
# -----------------------------
func exit():
	hitbox.monitoring = false

# -----------------------------
#     ATTACK FINISHED
# -----------------------------
func _on_attack_finished():
	# Only react to attack animations
	if not sprite.animation.begins_with("attacking"):
		return
	
	_check_floor_state()

# -----------------------------
#     FLOOR CHECK
# -----------------------------
func _check_floor_state():
	if not character.is_on_floor():
		state_machine.change_state("fallingstate")
	else:
		state_machine.change_state("idlestate")
