extends Node

const BROADCAST_PORT = 9999
const BROADCAST_INTERVAL = 1.5
const GAME_PORT = 7777
const SERVER_NAME = "LAN Game"

var udp := PacketPeerUDP.new()
var broadcast_timer := 0.0
var is_hosting := false

func start_broadcasting():
	is_hosting = true
	udp.set_broadcast_enabled(true)
	udp.bind(0)  # bind to any available port

func stop_broadcasting():
	is_hosting = false
	udp.close()

func _process(delta):
	if not is_hosting:
		return
	broadcast_timer += delta
	if broadcast_timer >= BROADCAST_INTERVAL:
		broadcast_timer = 0.0
		_send_broadcast()

func _send_broadcast():
	var data = JSON.stringify({
		"name": SERVER_NAME,
		"port": GAME_PORT
	})
	udp.set_dest_address("255.255.255.255", BROADCAST_PORT)
	udp.put_packet(data.to_utf8_buffer())
