extends StaticBody2D

@export var damage := 35
@export var damage_interval := 0.1

var damage_timer := 0.0
var player_in_area: CharacterBody2D = null

func _ready() -> void:
	set_process(false)

func _process(delta: float) -> void:
	if not _is_player_valid():
		_stop_damaging()
		return
	
	_update_damage_timer(delta)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if _is_player(body):
		_start_damaging(body)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if _is_player(body) and body == player_in_area:
		_stop_damaging()

func activate_node() -> void:
	queue_free()

func _is_player(body: Node2D) -> bool:
	return body.name == "Player"

func _is_player_valid() -> bool:
	return is_instance_valid(player_in_area)

func _start_damaging(body: CharacterBody2D) -> void:
	player_in_area = body
	damage_timer = 0.0
	set_process(true)
	body.character_damaged(damage, self)

func _stop_damaging() -> void:
	player_in_area = null
	damage_timer = 0.0
	set_process(false)

func _update_damage_timer(delta: float) -> void:
	damage_timer += delta
	if damage_timer >= damage_interval:
		player_in_area.character_damaged(damage, self)
		damage_timer = 0.0
