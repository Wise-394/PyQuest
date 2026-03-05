extends MarginContainer
# ─── Node References ─────────────────────────────────────
@onready var player_label : Label = $HBoxContainer/PlayerLabel
@onready var points_label : Label = $HBoxContainer/PointsLabel

# ─── Setup ───────────────────────────────────────────────
func setup(id: int, points: int) -> void:
	player_label.text = "Player %d" % id
	points_label.text = str(points)

func update_points(points: int) -> void:
	points_label.text = str(points)
