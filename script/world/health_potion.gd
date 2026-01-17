extends Area2D

@export var heal_amount := 30
@export var bob_height := 6.0
@export var bob_speed := 3.0

var base_y := 0.0
var time := 0.0

func _ready():
	base_y = global_position.y

func _process(delta):
	time += delta * bob_speed
	global_position.y = base_y + sin(time) * bob_height

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		heal_player(body)
		queue_free()

func heal_player(player):
	player.heal(heal_amount)
