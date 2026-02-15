extends Area2D

@onready var reaper: Node = $"../.."

var _hit_bodies: Array[Node] = []

func activate() -> void:
	_hit_bodies.clear()
	monitoring = true

func deactivate() -> void:
	monitoring = false

func reset() -> void:
	_hit_bodies.clear()
	monitoring = false

func _on_body_entered(body: Node2D) -> void:
	if not monitoring:
		return
	if body.is_in_group("player") and body not in _hit_bodies:
		_hit_bodies.append(body)
		body.character_damaged(reaper.damage, reaper)
