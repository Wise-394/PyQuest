extends Node2D

# ─── Constants ───────────────────────────────────────────
const PLAYER_SCENE := preload("res://multiplayer/scene/character/NetworkPlayer.tscn")

# ─── Node References ─────────────────────────────────────
@onready var players_node : Node2D = $Players
@onready var spawn_points : Node2D = $SpawnPoints

# ─── Lifecycle ───────────────────────────────────────────
func _ready() -> void:
	if multiplayer.is_server():
		_spawn_all_players()
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)

# ─── Spawning ────────────────────────────────────────────
func _spawn_all_players() -> void:
	var ids := multiplayer.get_peers()
	ids.append(multiplayer.get_unique_id())

	for i in ids.size():
		_spawn_player.rpc(ids[i], i % spawn_points.get_child_count())

@rpc("authority", "call_local")
func _spawn_player(id: int, spawn_index: int) -> void:
	if players_node.has_node(str(id)):
		return
	var player      := PLAYER_SCENE.instantiate()
	player.name      = str(id)
	player.position  = spawn_points.get_child(spawn_index).position
	player.set_multiplayer_authority(id)  # ← add this line
	players_node.add_child(player)

# ─── Peer Events ─────────────────────────────────────────
func _on_peer_disconnected(id: int) -> void:
	if players_node.has_node(str(id)):
		players_node.get_node(str(id)).queue_free()
