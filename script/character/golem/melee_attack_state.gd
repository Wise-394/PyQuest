extends State

@export var attack_count := 2  
@export var attack_forward_distance := 50.0  
@export var attack_delay := 0.5              
@export var attack_forward_speed := 100.0    

var current_attack := 0
@onready var attack_timer : Timer = $AttackTimer
var moving_forward := false
var forward_target_x := 0.0

func enter():
	init_references()
	current_attack = 0
	_start_attack()
	
	if not sprite.animation_finished.is_connected(_on_animation_finished):
		sprite.animation_finished.connect(_on_animation_finished)
		
	if not attack_timer.timeout.is_connected(_on_attack_timer_timeout):
		attack_timer.timeout.connect(_on_attack_timer_timeout)

func exit():
	if sprite.animation_finished.is_connected(_on_animation_finished):
		sprite.animation_finished.disconnect(_on_animation_finished)
		
	if attack_timer.timeout.is_connected(_on_attack_timer_timeout):
		attack_timer.timeout.disconnect(_on_attack_timer_timeout)
		
	attack_timer.stop()
	character.velocity = Vector2.ZERO
	moving_forward = false

# ---------------------------
#   ATTACK LOGIC
# ---------------------------
func _start_attack():
	sprite.play("melee")

func _on_animation_finished():
	if sprite.animation != "melee":
		return

	# Deal damage at the end of the attack
	if character.hitbox.player_in_hitbox:
		character.player.character_damaged(20, character)

	current_attack += 1

	if current_attack < attack_count:
		sprite.play("move")
		moving_forward = true
		forward_target_x = character.global_position.x + attack_forward_distance * character.direction
		attack_timer.start(attack_delay)
	else:
		state_machine.change_state("idlestate")

func _on_attack_timer_timeout():
	_start_attack()

# ---------------------------
#   PHYSICS UPDATE
# ---------------------------
func physics_update(_delta):
	if moving_forward:
		var direction = sign(forward_target_x - character.global_position.x)
		character.velocity.x = direction * attack_forward_speed
		
		# Stop when reached the forward target
		if abs(forward_target_x - character.global_position.x) <= 1.0:
			character.velocity.x = 0
			moving_forward = false
	
	character.move_and_slide()
	
	
	#at the end of attack when character.hitbox.player_in_hitbox is not null then do character.damaged(20,self)
