extends Control

# ─── Constants ───────────────────────────────────────────
const PLAYER_LIST_ITEM := preload("res://multiplayer/scene/ui/player_list_item.tscn")

# ─── Node References ─────────────────────────────────────
@onready var list : VBoxContainer = $ScrollContainer/VBoxContainer

# ─── Lifecycle ───────────────────────────────────────────
func _ready() -> void:
	var game_world := get_tree().root.get_node("GameWorld")
	game_world.points_updated.connect(_on_points_updated)
	_populate_list()

# ─── List ────────────────────────────────────────────────
func _populate_list() -> void:
	var ids := multiplayer.get_peers()
	ids.append(multiplayer.get_unique_id())
	for id in ids:
		_add_player(id)

func _add_player(id: int) -> void:
	var item := PLAYER_LIST_ITEM.instantiate()
	item.name = str(id)
	list.add_child(item)
	item.setup(id, 0)

func _sort_by_points() -> void:
	var items := list.get_children()
	# host always goes to bottom
	items.sort_custom(func(a, b):
		if a.name == "1": return false
		if b.name == "1": return true
		return a.get_points() > b.get_points()
	)
	for item in items:
		list.move_child(item, -1)

# ─── Signals ─────────────────────────────────────────────
func _on_points_updated(player_id: int, points: int) -> void:
	if list.has_node(str(player_id)):
		list.get_node(str(player_id)).update_points(points)
		_sort_by_points()
