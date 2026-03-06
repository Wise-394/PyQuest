extends MarginContainer

# ─── Node References ─────────────────────────────────────
@onready var player_label : Label = $HBoxContainer/PlayerLabel
@onready var points_label : Label = $HBoxContainer/PointsLabel

# ─── State ───────────────────────────────────────────────
var current_points : int = 0

# ─── Setup ───────────────────────────────────────────────
func setup(id: int, points: int) -> void:
	current_points    = points
	var game_world    := get_tree().root.get_node("GameWorld")
	var username      = game_world.players.get(str(id), {}).get("username", "Player")
	player_label.text  = username
	points_label.text  = "" if id == 1 else str(points)

func update_points(points: int) -> void:
	current_points    = points
	points_label.text = str(points)

func update_username(username: String) -> void:
	var id            := int(name)
	player_label.text  = username + " [Host]" if id == 1 else username

func get_points() -> int:
	return current_points
