extends MarginContainer

# ─── Node References ─────────────────────────────────────
@onready var player_label : Label = $HBoxContainer/PlayerLabel
@onready var points_label : Label = $HBoxContainer/PointsLabel

# ─── State ───────────────────────────────────────────────
var current_points : int = 0

# ─── Setup ───────────────────────────────────────────────
func setup(id: int, points: int) -> void:
	current_points    = points
	player_label.text = "Player %d" % id 
	points_label.text = "Host" if id == 1 else str(points)

func update_points(points: int) -> void:
	current_points    = points
	points_label.text = str(points)

func get_points() -> int:
	return current_points
