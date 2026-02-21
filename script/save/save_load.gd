extends Node

# ============================================================
#  SaveManager — handles up to MAX_SLOTS JSON save files
#  stored in user://saves/slot_0.json … slot_3.json
# ============================================================

const SAVE_DIR  : String = "user://saves/"
const MAX_SLOTS : int    = 4

# Which slot is currently loaded (-1 = none)
var active_slot : int = -1
var current_level = 0
var highest_unlocked_level = 0
# The live save data. Add new fields here as the game grows.
var data : Dictionary = {
	"player_name"   : "Player",
	"coins"         : 0,
	"highest_unlocked_level": 0,
	"passcode" : "",
	"unlocked_achievements" : [],
}


# ── Lifecycle ───────────────────────────────────────────────

func _ready() -> void:
	DirAccess.make_dir_absolute(SAVE_DIR)


# ── Internal helpers ─────────────────────────────────────────

func _slot_path(slot: int) -> String:
	return SAVE_DIR + "slot_%d.json" % slot

func _default_data(player_name: String) -> Dictionary:
	return {
		"player_name"   : player_name,
		"coins"         : 0,
		"highest_unlocked_level" : 0,
		"passcode" : "",
		"unlocked_achievements" : [],
	}


# ── Single-slot operations ───────────────────────────────────

## Load slot into memory. Returns true on success.
func load_slot(slot: int) -> bool:
	var path := _slot_path(slot)

	if not FileAccess.file_exists(path):
		push_warning("SaveManager: slot %d does not exist." % slot)
		return false

	var file := FileAccess.open(path, FileAccess.READ)
	if not file:
		push_error("SaveManager: could not open slot %d for reading." % slot)
		return false

	var json := JSON.new()
	var err  := json.parse(file.get_as_text())
	file.close()

	if err != OK:
		push_error("SaveManager: slot %d parse error — %s" % [slot, json.get_error_message()])
		return false

	var parsed = json.get_data()
	if parsed is not Dictionary:
		push_warning("SaveManager: slot %d is corrupted." % slot)
		return false

	# Merge file values on top of defaults so new keys are never missing
	data = _default_data(parsed.get("player_name", "Player"))
	for key in parsed:
		data[key] = parsed[key]

	active_slot = slot
	return true


## Write the current in-memory data to the active slot.
func save_slot() -> void:
	if active_slot == -1:
		push_error("SaveManager: no active slot — call new_slot() or load_slot() first.")
		return

	var file := FileAccess.open(_slot_path(active_slot), FileAccess.WRITE)
	if not file:
		push_error("SaveManager: could not open slot %d for writing." % active_slot)
		return

	file.store_string(JSON.stringify(data, "\t"))
	file.close()


## Create a fresh save in the given slot and make it active.
func new_slot(slot: int, player_name: String) -> void:
	active_slot = slot
	data        = _default_data(player_name)
	save_slot()


## Permanently delete a slot file from disk.
func delete_slot(slot: int) -> void:
	var path := _slot_path(slot)
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(path)
	if active_slot == slot:
		active_slot = -1


# ── Slot-select screen helper ────────────────────────────────

## Returns an Array of Dictionaries, one per slot, ready for a UI list.
## Each entry is guaranteed to have at least { slot, exists }.
func get_all_slots() -> Array:
	var slots := []

	for i in range(MAX_SLOTS):
		var path := _slot_path(i)

		if not FileAccess.file_exists(path):
			slots.append({ "slot": i, "exists": false })
			continue

		var file := FileAccess.open(path, FileAccess.READ)
		if not file:
			slots.append({ "slot": i, "exists": false })
			continue

		var json := JSON.new()
		var raw  := file.get_as_text()
		file.close()

		if json.parse(raw) != OK:
			slots.append({ "slot": i, "exists": false })
			continue

		var saved = json.get_data()
		slots.append({
			"slot"          : i,
			"exists"        : true,
			"is_active"     : i == active_slot,
			"player_name"   : saved.get("player_name",   "Unknown"),
			"coins"         : saved.get("coins",         0),
			"highest_unlocked_level" : saved.get("highest_unlocked_level", 0),
		})

	return slots
