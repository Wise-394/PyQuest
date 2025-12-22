extends Area2D

@export var damage := 45
@export var damage_interval := 0.2

var player: Node2D = null
var damage_elapsed := 0.0

func _physics_process(delta: float) -> void:
	if player == null:
		return

	damage_elapsed += delta
	if damage_elapsed >= damage_interval:
		player.character_damaged(damage, self)
		damage_elapsed = 0.0

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player = body
		damage_elapsed = 0.0

func _on_body_exited(body: Node2D) -> void:
	if body == player:
		player = null
