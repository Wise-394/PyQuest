extends Control

# ─── Constants ───────────────────────────────────────────
const BROADCAST_PORT := 9999
const SCAN_DURATION  := 5.0

# ─── State ───────────────────────────────────────────────
var udp      := PacketPeerUDP.new()
var servers  := {}
var scan_timer := 0.0
var scanning   := false

# ─── Node References ─────────────────────────────────────
@onready var server_list   : VBoxContainer = $CanvasLayer/Panel/MarginContainer/VBoxContainer/ScrollContainer/ServerList
@onready var status_label  : Label         = $CanvasLayer/Panel/MarginContainer/VBoxContainer/StatusLabel
@onready var refresh_button: Button        = $CanvasLayer/Panel/MarginContainer/VBoxContainer/RefreshButton
@onready var back_button   : Button        = $CanvasLayer/Panel/MarginContainer/VBoxContainer/BackButton

# ─── Lifecycle ───────────────────────────────────────────
func _ready() -> void:
	refresh_button.pressed.connect(start_scan)
	back_button.pressed.connect(_on_back_pressed)
	start_scan()

func _process(delta: float) -> void:
	if not scanning:
		return

	scan_timer += delta

	if scan_timer >= SCAN_DURATION:
		_finish_scan()
		return

	_read_udp_packets()

# ─── Scanning ────────────────────────────────────────────
func start_scan() -> void:
	servers.clear()
	_clear_list()
	scan_timer = 0.0
	scanning   = true
	status_label.text = "Scanning for servers..."
	udp.close()
	udp.bind(BROADCAST_PORT)

func _finish_scan() -> void:
	scanning = false
	udp.close()
	status_label.text = "No servers found." if servers.is_empty() \
		else "Found %d server(s)." % servers.size()

func _read_udp_packets() -> void:
	while udp.get_available_packet_count() > 0:
		print("Packet received!")
		var raw_packet := udp.get_packet()
		var sender_ip  := udp.get_packet_ip()
		_parse_packet(raw_packet, sender_ip)

func _parse_packet(raw: PackedByteArray, sender_ip: String) -> void:
	var json := JSON.new()
	if json.parse(raw.get_string_from_utf8()) != OK:
		return

	var data: Dictionary = json.get_data()
	var key := "%s:%d" % [sender_ip, data["port"]]

	if servers.has(key):
		return

	servers[key] = {
		"name": data["name"],
		"ip":   sender_ip,
		"port": data["port"]
	}
	_add_server_button(servers[key])

# ─── UI ──────────────────────────────────────────────────
func _add_server_button(server: Dictionary) -> void:
	if server_list == null:
		push_error("server_list node is null — check @onready path")
		return

	var btn := Button.new()
	btn.text = "%s  —  %s:%d" % [server["name"], server["ip"], server["port"]]
	btn.custom_minimum_size = Vector2(300, 40)
	btn.pressed.connect(_on_server_selected.bind(server))
	server_list.add_child(btn)

func _clear_list() -> void:
	for child in server_list.get_children():
		server_list.remove_child(child)
		child.free()

# ─── Callbacks ───────────────────────────────────────────
func _on_server_selected(server: Dictionary) -> void:
	var peer := ENetMultiplayerPeer.new()
	peer.create_client(server["ip"], server["port"])
	multiplayer.multiplayer_peer = peer
	get_tree().change_scene_to_file("res://multiplayer/scene/lobby.tscn")

func _on_back_pressed() -> void:
	udp.close()
	get_tree().change_scene_to_file("res://multiplayer/scene/multiplayer_menu.tscn")
