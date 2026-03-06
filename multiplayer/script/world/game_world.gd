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

# ─── Signals ─────────────────────────────────────────────
signal points_updated(player_id: int, points: int)

# ─── State ───────────────────────────────────────────────
var players         := {}  # { "id": { "name": "Player 1", "points": 0 } }
var question_object := {
	"question_string"   : "",
	"completion_points" : "",
}

# ─── Lifecycle ───────────────────────────────────────────
func _ready() -> void:
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	if not multiplayer.is_server():
		multiplayer.server_disconnected.connect(_on_host_disconnected)
	if multiplayer.is_server():
		_spawn_all_players()
		_spawn_checklist()

func _on_host_disconnected() -> void:
	multiplayer.multiplayer_peer = null
	get_tree().change_scene_to_file("res://multiplayer/scene/ui/disconnection_notice.tscn")
	
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
	players[str(id)] = {
		"name"  : "Player %d" % id,
		"points": 0
	}

# ─── Checklist ───────────────────────────────────────────
func _spawn_checklist() -> void:
	var checklist    := CHECKLIST_SCENE.instantiate()
	checklist.name    = "PlayerCheckList"
	checklist.visible = false
	canvas_layer.add_child(checklist)

# ─── Question ────────────────────────────────────────────
func set_question(question: String, points: String) -> void:
	_sync_question.rpc(question, points)
	announce("A new question has been created! Find the note and solve it.")

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
	
# ─── Round Management ────────────────────────────────────
func next_round() -> void:
	if not multiplayer.is_server():
		return
	announce("Moving to the next round!")
	_reset_round.rpc()
	

@rpc("authority", "call_local")
func _reset_round() -> void:
	# clear question
	question_object["question_string"]   = ""
	question_object["completion_points"] = ""

	# remove question note
	var existing := get_node_or_null("QuestionNote")
	if existing:
		existing.queue_free()

	# clear checklist
	if multiplayer.is_server():
		var checklist := canvas_layer.get_node_or_null("PlayerCheckList")
		if checklist:
			checklist.clear()

	# reset all player states and respawn at spawn points
	var ids := players.keys()
	for i in ids.size():
		var id     = ids[i]
		var player := players_node.get_node_or_null(id)
		if player:
			player.question_discovered(false)
			player.code_checked(false)
			if player.is_multiplayer_authority():
				var spawn_index := i % player_spawn_points.get_child_count()
				player.position  = player_spawn_points.get_child(spawn_index).position

@rpc("any_peer")
func announce(message: String) -> void:
	if not multiplayer.is_server():
		return
	_show_announcement.rpc("[SYSTEM] " + message)

@rpc("any_peer")
func chat(player_id: int, message: String) -> void:
	if not multiplayer.is_server():
		return
	_show_announcement.rpc("Player %d: %s" % [player_id, message])

@rpc("authority", "call_local")
func _show_announcement(message: String) -> void:
	var box := canvas_layer.get_node_or_null("ChatBox")
	if box:
		box.add_announcement(message)

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
	if not players.has(str(player_id)):
		return
	players[str(player_id)]["points"] += points
	points_updated.emit(player_id, players[str(player_id)]["points"])
	announce("Player %d's answer is correct! +%d points" % [player_id, points])

@rpc("authority")
func notify_rejected(player_id: int) -> void:
	announce("Player %d's answer is incorrect!" % player_id)

# ─── Peer Events ─────────────────────────────────────────
func _on_peer_disconnected(id: int) -> void:
	players.erase(str(id))
	if players_node.has_node(str(id)):
		players_node.get_node(str(id)).queue_free()
