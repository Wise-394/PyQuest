extends Control

# ─── Constants ───────────────────────────────────────────
const BROADCAST_PORT     := 9999
const BROADCAST_INTERVAL := 1.5
const GAME_PORT          := 7777
const SERVER_NAME        := "LAN Game"
const GAME_SCENE         := "res://multiplayer/scene/world/game_world.tscn"

# ─── State ───────────────────────────────────────────────
var udp              := PacketPeerUDP.new()
var broadcast_timer  := 0.0
var player_usernames := {}

# ─── Node References ─────────────────────────────────────
@onready var player_list  : VBoxContainer = $CanvasLayer/Panel/VBoxContainer/PlayerList
@onready var status_label : Label         = $CanvasLayer/Panel/VBoxContainer/StatusLabel
@onready var start_button : Button        = $CanvasLayer/Panel/VBoxContainer/StartButton
@onready var leave_button : Button        = $CanvasLayer/Panel/VBoxContainer/LeaveButton

# ─── Lifecycle ───────────────────────────────────────────
func _ready() -> void:
	start_button.pressed.connect(_on_start_pressed)
	leave_button.pressed.connect(_on_leave_pressed)

	# register own username immediately
	var username = SaveLoad.data.get("player_name", "Player")
	player_usernames[multiplayer.get_unique_id()] = username

	if multiplayer.is_server():
		_setup_as_host()
	else:
		_setup_as_client()

	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	_refresh_player_list()

func _exit_tree() -> void:
	udp.close()

func _process(delta: float) -> void:
	if multiplayer.multiplayer_peer == null:
		return
	if not multiplayer.is_server():
		return
	broadcast_timer += delta
	if broadcast_timer >= BROADCAST_INTERVAL:
		broadcast_timer = 0.0
		_send_broadcast()

# ─── Setup ───────────────────────────────────────────────
func _setup_as_host() -> void:
	status_label.text    = "Waiting for players..."
	start_button.visible = true
	udp.set_broadcast_enabled(true)
	udp.bind(0)

func _setup_as_client() -> void:
	status_label.text    = "Waiting for host to start..."
	start_button.visible = false
	multiplayer.server_disconnected.connect(_on_host_disconnected)

func _on_host_disconnected() -> void:
	multiplayer.multiplayer_peer = null
	udp.close()
	get_tree().change_scene_to_file("res://multiplayer/scene/disconnected.tscn")

# ─── Username Sync ───────────────────────────────────────
@rpc("any_peer", "call_local")
func _sync_username(id: int, username: String) -> void:
	player_usernames[id] = username
	_refresh_player_list()

# ─── Broadcasting ────────────────────────────────────────
func _get_broadcast_address() -> String:
	for address in IP.get_local_addresses():
		if address == "127.0.0.1" or ":" in address:
			continue
		if address.begins_with("172.") or address.begins_with("169.254."):
			continue
		if address.begins_with("192.168."):
			var parts := address.split(".")
			return "%s.%s.%s.255" % [parts[0], parts[1], parts[2]]
	for address in IP.get_local_addresses():
		if address == "127.0.0.1" or ":" in address:
			continue
		if address.begins_with("172.") or address.begins_with("169.254."):
			continue
		var parts := address.split(".")
		if parts.size() == 4:
			return "%s.%s.%s.255" % [parts[0], parts[1], parts[2]]
	return "255.255.255.255"

func _send_broadcast() -> void:
	var broadcast := _get_broadcast_address()
	var data      := JSON.stringify({"name": SERVER_NAME, "port": GAME_PORT})
	udp.set_dest_address(broadcast, BROADCAST_PORT)
	udp.put_packet(data.to_utf8_buffer())

# ─── Player List ─────────────────────────────────────────
func _refresh_player_list() -> void:
	for child in player_list.get_children():
		player_list.remove_child(child)
		child.free()
	for id in multiplayer.get_peers():
		_add_player_label(id)
	_add_player_label(multiplayer.get_unique_id())

func _add_player_label(id: int) -> void:
	var label    := Label.new()
	var username = player_usernames.get(id, "Player")
	label.text    = username
	if id == multiplayer.get_unique_id():
		label.text += " (You)"
	if id == 1:
		label.text += " [Host]"
	label.add_theme_color_override("font_color", Color("#dd8f61"))
	label.add_theme_color_override("font_outline_color", Color("#33323d"))
	label.add_theme_constant_override("outline_size", 10)
	player_list.add_child(label)

# ─── Peer Events ─────────────────────────────────────────
func _on_peer_connected(id: int) -> void:
	var username = SaveLoad.data.get("player_name", "Player")
	_sync_username.rpc(multiplayer.get_unique_id(), username)
	_refresh_player_list()

func _on_peer_disconnected(id: int) -> void:
	player_usernames.erase(id)
	_refresh_player_list()

# ─── Callbacks ───────────────────────────────────────────
func _on_start_pressed() -> void:
	_load_game.rpc()

func _on_leave_pressed() -> void:
	multiplayer.multiplayer_peer = null
	udp.close()
	get_tree().change_scene_to_file("res://multiplayer/scene/multiplayer_menu.tscn")

@rpc("call_local")
func _load_game() -> void:
	get_tree().change_scene_to_file(GAME_SCENE)
