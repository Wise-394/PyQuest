extends Node2D

# ─── Constants ───────────────────────────────────────────
const PLAYER_SCENE    := preload("res://multiplayer/scene/character/NetworkPlayer.tscn")
const QUESTION_NOTE   := preload("res://multiplayer/scene/world/question_note.tscn")
const CHECKLIST_SCENE := preload("res://scene/ui/player_check_list.tscn")

# ─── Node References ─────────────────────────────────────
@onready var players_node          : Node2D      = $Players
@onready var player_spawn_points   : Node2D      = $PlayerSpawnPoints
@onready var question_spawn_points : Node2D      = $QuestionSpawnPoints
@onready var canvas_layer          : CanvasLayer = $CanvasLayer

# ─── State ───────────────────────────────────────────────
var player_points   := {}
var question_object := {
	"question_string"   : "",
	"completion_points" : "",
}

# ─── Lifecycle ───────────────────────────────────────────
func _ready() -> void:
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	if multiplayer.is_server():
		_spawn_all_players()
		_spawn_checklist()

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

# ─── Checklist ───────────────────────────────────────────
func _spawn_checklist() -> void:
	var checklist    := CHECKLIST_SCENE.instantiate()
	checklist.name    = "PlayerCheckList"
	checklist.visible = false
	canvas_layer.add_child(checklist)

# ─── Question ────────────────────────────────────────────
func set_question(question: String, points: String) -> void:
	_sync_question.rpc(question, points)

@rpc("authority", "call_local")
func _sync_question(question: String, points: String) -> void:
	question_object["question_string"]   = question
	question_object["completion_points"] = points
	if multiplayer.is_server():
		var spawn_index := randi() % question_spawn_points.get_child_count()
		_spawn_question_note.rpc(spawn_index)

@rpc("authority", "call_local")
func _spawn_question_note(spawn_index: int) -> void:
	var existing := get_node_or_null("QuestionNote")
	if existing:
		existing.queue_free()
	var note      := QUESTION_NOTE.instantiate()
	note.name      = "QuestionNote"
	note.position  = question_spawn_points.get_child(spawn_index).position
	add_child(note)

# ─── Submissions ─────────────────────────────────────────
@rpc("any_peer")
func submit_answer(player_id: int, code: String) -> void:
	if not multiplayer.is_server():
		return
	var checklist := canvas_layer.get_node_or_null("PlayerCheckList")
	if checklist == null:
		push_error("PlayerCheckList not found in CanvasLayer!")
		return
	checklist.add_submission(player_id, code)

# ─── Points ──────────────────────────────────────────────
@rpc("authority", "call_local")
func award_points(player_id: int, points: int) -> void:
	if not player_points.has(str(player_id)):
		player_points[str(player_id)] = 0
	player_points[str(player_id)] += points

@rpc("authority")
func notify_rejected(player_id: int) -> void:
	pass  # TODO: show rejection UI to player

# ─── Peer Events ─────────────────────────────────────────
func _on_peer_disconnected(id: int) -> void:
	if players_node.has_node(str(id)):
		players_node.get_node(str(id)).queue_free()
