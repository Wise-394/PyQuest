extends Node2D

# ─── Constants ───────────────────────────────────────────
const PLAYER_SCENE := preload("res://multiplayer/scene/character/NetworkPlayer.tscn")

# ─── Node References ─────────────────────────────────────
@onready var players_node          : Node2D = $Players
@onready var player_spawn_points   : Node2D = $PlayerSpawnPoints
@onready var question_spawn_points : Node2D = $QuestionSpawnPoints

var question_note := preload("res://multiplayer/scene/world/question_note.tscn")

# ─── State ───────────────────────────────────────────────
signal state_changed(state)

enum game_state {
	PREQUESTION,
	ROUND_START,
}

var current_state := game_state.PREQUESTION
var question_object := {
	"question_string"   : "",
	"completion_points" : "",
}

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
		_spawn_player.rpc(ids[i], i % player_spawn_points.get_child_count())

@rpc("authority", "call_local")
func _spawn_player(id: int, spawn_index: int) -> void:
	if players_node.has_node(str(id)):
		return
	var player     := PLAYER_SCENE.instantiate()
	player.name     = str(id)
	player.position = player_spawn_points.get_child(spawn_index).position
	player.set_multiplayer_authority(id)
	players_node.add_child(player)

# ─── Game State ──────────────────────────────────────────
func set_question(question: String, points: String) -> void:
	_sync_question.rpc(question, points)

@rpc("authority", "call_local")
func _sync_question(question: String, points: String) -> void:
	question_object["question_string"]   = question
	question_object["completion_points"] = points
	# only host triggers the state change
	if multiplayer.is_server():
		change_state.rpc(game_state.ROUND_START as int)

@rpc("authority", "call_local")
func change_state(state: int) -> void:
	current_state = state as game_state
	state_changed.emit(state as game_state)

	if current_state == game_state.ROUND_START:
		_start_round()
		
func _start_round():
	if multiplayer.is_server():
			var spawn_index := randi() % question_spawn_points.get_child_count()
			_spawn_question_note.rpc(spawn_index)
			
# ─── Question Note ───────────────────────────────────────
@rpc("authority", "call_local")
func _spawn_question_note(spawn_index: int) -> void:
	var existing := get_node_or_null("QuestionNote")
	if existing:
		existing.queue_free()
	var note      := question_note.instantiate()
	note.name      = "QuestionNote"
	note.position  = question_spawn_points.get_child(spawn_index).position
	add_child(note)

# ─── Peer Events ─────────────────────────────────────────
func _on_peer_disconnected(id: int) -> void:
	if players_node.has_node(str(id)):
		players_node.get_node(str(id)).queue_free()
