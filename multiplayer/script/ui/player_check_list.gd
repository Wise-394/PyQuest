extends Control

# ─── Constants ───────────────────────────────────────────
const CHECKLIST_ITEM := preload("res://multiplayer/scene/ui/player_check_list_item.tscn")

# ─── Node References ─────────────────────────────────────
@onready var list : VBoxContainer = $Panel/ScrollContainer/VBoxContainer

# ─── Lifecycle ───────────────────────────────────────────
func _ready() -> void:
	visible = false

# ─── Submissions ─────────────────────────────────────────
func add_submission(player_id: int, code: String) -> void:
	if list.has_node(str(player_id)):
		list.get_node(str(player_id)).queue_free()
	var game_world := get_tree().root.get_node("GameWorld")
	var username   = game_world.players.get(str(player_id), {}).get("username", "Player")
	var item       := CHECKLIST_ITEM.instantiate()
	item.name       = str(player_id)
	list.add_child(item)
	item.setup(player_id, code, username)
	
func remove_submission(player_id: int) -> void:
	if list.has_node(str(player_id)):
		list.get_node(str(player_id)).queue_free()
# ─── Callbacks ───────────────────────────────────────────
func _on_close_button_pressed() -> void:
	visible = false

func clear() -> void:
	for child in list.get_children():
		list.remove_child(child)
		child.free()
