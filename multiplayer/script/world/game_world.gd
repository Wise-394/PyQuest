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
signal username_updated(player_id: int, username: String)
signal submission_updated
signal question_updated

# ─── State ───────────────────────────────────────────────
var players         := {}
var checked_players : Array = []
var question_object := {
	"question_string"   : "",
	"completion_points" : "",
}

# ─── Lifecycle ───────────────────────────────────────────
func _ready() -> void:
	multiplayer.peer_connected.connect(_on_peer_connected_server)
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
		"username": "Player",
		"points"  : 0
	}
	if player.is_multiplayer_authority():
		var username = SaveLoad.data.get("player_name", "Player")
		if multiplayer.is_server():
			_broadcast_player_name.rpc(id, username)
		else:
			_sync_player_name.rpc_id(1, id, username)

# ─── Username Sync ───────────────────────────────────────
func _on_peer_connected_server(id: int) -> void:
	if not multiplayer.is_server():
		return
	for player_id in players.keys():
		var username : String = players[player_id]["username"]
		_broadcast_player_name.rpc_id(id, int(player_id), username)

@rpc("any_peer")
func _sync_player_name(id: int, username: String) -> void:
	if not multiplayer.is_server():
		return
	_broadcast_player_name.rpc(id, username)

@rpc("authority", "call_local")
func _broadcast_player_name(id: int, username: String) -> void:
	if not players.has(str(id)):
		return
	players[str(id)]["username"] = username
	var player := players_node.get_node_or_null(str(id))
	if player:
		player.username_label.text = username
	username_updated.emit(id, username)

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
		question_updated.emit()
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
	checked_players.clear()
	question_object["question_string"]   = ""
	question_object["completion_points"] = ""
	var existing := get_node_or_null("QuestionNote")
	if existing:
		existing.queue_free()
	if multiplayer.is_server():
		question_updated.emit()
		var checklist := canvas_layer.get_node_or_null("PlayerCheckList")
		if checklist:
			checklist.clear()
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

# ─── Announcements & Chat ────────────────────────────────
@rpc("any_peer")
func announce(message: String) -> void:
	if not multiplayer.is_server():
		return
	_show_announcement.rpc("[SYSTEM] " + message)

@rpc("any_peer")
func chat(player_id: int, message: String) -> void:
	if not multiplayer.is_server():
		return
	var username : String = players.get(str(player_id), {}).get("username", "Player")
	_show_announcement.rpc("%s: %s" % [username, message])

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
func _on_player_checked(player_id: int) -> void:
	if not checked_players.has(player_id):
		checked_players.append(player_id)
	submission_updated.emit()

@rpc("authority", "call_local")
func award_points(player_id: int, points: int) -> void:
	if not players.has(str(player_id)):
		return
	players[str(player_id)]["points"] += points
	points_updated.emit(player_id, players[str(player_id)]["points"])
	var username : String = players[str(player_id)]["username"]
	announce("%s's answer is correct! +%d points" % [username, points])

@rpc("authority")
func notify_rejected(player_id: int) -> void:
	var username : String = players.get(str(player_id), {}).get("username", "Player")
	announce("%s's answer is incorrect!" % username)

# ─── Peer Events ─────────────────────────────────────────
func _on_peer_disconnected(id: int) -> void:
	var username : String = players.get(str(id), {}).get("username", "Player")
	announce("%s has left the game." % username)
	players.erase(str(id))
	if players_node.has_node(str(id)):
		players_node.get_node(str(id)).queue_free()
