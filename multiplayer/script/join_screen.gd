extends Control

# ─── Constants ───────────────────────────────────────────
const BROADCAST_PORT := 9999
const SCAN_DURATION  := 5.0
const GAME_PORT      := 7777

# ─── State ───────────────────────────────────────────────
var udp                := PacketPeerUDP.new()
var servers            := {}
var scan_timer         := 0.0
var scanning           := false
var connecting         := false
var connection_timeout := 0.0

# ─── Node References ─────────────────────────────────────
@onready var server_list    : VBoxContainer = $CanvasLayer/Panel/MarginContainer/VBoxContainer/ScrollContainer/ServerList
@onready var status_label   : Label         = $CanvasLayer/Panel/MarginContainer/VBoxContainer/StatusLabel
@onready var refresh_button : Button        = $CanvasLayer/Panel/MarginContainer/VBoxContainer/RefreshButton
@onready var back_button    : Button        = $CanvasLayer/Panel/MarginContainer/VBoxContainer/BackButton
@onready var ip_input       : LineEdit      = $CanvasLayer/Panel/MarginContainer/VBoxContainer/IPInput
@onready var connect_button : Button        = $CanvasLayer/Panel/MarginContainer/VBoxContainer/ConnectButton

# ─── Lifecycle ───────────────────────────────────────────
func _ready() -> void:
	refresh_button.pressed.connect(start_scan)
	back_button.pressed.connect(_on_back_pressed)
	connect_button.pressed.connect(_on_manual_connect_pressed)
	ip_input.placeholder_text = "Type host IP manually..."
	start_scan()

func _process(delta: float) -> void:
	if scanning:
		scan_timer += delta
		if scan_timer >= SCAN_DURATION:
			_finish_scan()
		else:
			_read_udp_packets()

	if connecting:
		connection_timeout += delta
		if connection_timeout >= 5.0:
			status_label.text = "Connection timed out."
			multiplayer.multiplayer_peer = null
			connecting = false
			_reset_ui()

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
	servers[key] = {"name": data["name"], "ip": sender_ip, "port": data["port"]}
	_add_server_button(servers[key])

# ─── UI ──────────────────────────────────────────────────
func _add_server_button(server: Dictionary) -> void:
	var btn := Button.new()
	btn.text = "%s  —  %s:%d" % [server["name"], server["ip"], server["port"]]
	btn.custom_minimum_size = Vector2(300, 40)
	btn.pressed.connect(_on_server_selected.bind(server))
	server_list.add_child(btn)

func _clear_list() -> void:
	for child in server_list.get_children():
		server_list.remove_child(child)
		child.free()

func _reset_ui() -> void:
	connect_button.disabled = false
	refresh_button.disabled = false
	ip_input.editable       = true

# ─── Callbacks ───────────────────────────────────────────
func _on_server_selected(server: Dictionary) -> void:
	_connect_to(server["ip"], server["port"])

func _on_manual_connect_pressed() -> void:
	var ip := ip_input.text.strip_edges()
	if ip == "":
		status_label.text = "Enter an IP address first."
		return
	var parts := ip.split(".")
	if parts.size() != 4:
		status_label.text = "Invalid IP format. Example: 192.168.1.5"
		return
	for part in parts:
		if not part.is_valid_int() or int(part) < 0 or int(part) > 255:
			status_label.text = "Invalid IP format. Example: 192.168.1.5"
			return
	_connect_to(ip, GAME_PORT)

func _connect_to(ip: String, port: int) -> void:
	connect_button.disabled = true
	refresh_button.disabled = true
	ip_input.editable       = false
	status_label.text       = "Connecting to %s..." % ip

	var peer := ENetMultiplayerPeer.new()
	var err  := peer.create_client(ip, port)
	if err != OK:
		status_label.text = "Failed to start connection: %s" % err
		_reset_ui()
		return

	multiplayer.multiplayer_peer = peer
	connecting         = true
	connection_timeout = 0.0
	multiplayer.connected_to_server.connect(_on_connected)
	multiplayer.connection_failed.connect(_on_connection_failed)

func _on_connected() -> void:
	connecting = false
	get_tree().change_scene_to_file("res://multiplayer/scene/lobby.tscn")

func _on_connection_failed() -> void:
	connecting = false
	status_label.text = "Connection failed. Check IP and try again."
	multiplayer.multiplayer_peer = null
	_reset_ui()

func _on_back_pressed() -> void:
	udp.close()
	get_tree().change_scene_to_file("res://multiplayer/scene/multiplayer_menu.tscn")
