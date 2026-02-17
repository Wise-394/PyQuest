extends Node

const SAVE_DIR = "user://saves/"
const MAX_SLOTS = 4

var current_slot: int = -1  # -1 means no slot loaded
var contents: Dictionary = {
	"player_name": "Player",
	"current_level": 0,
	"coins": 0
}

func _ready() -> void:
	# Make sure the saves directory exists
	DirAccess.make_dir_absolute(SAVE_DIR)

# --- Slot path helper ---
func _slot_path(slot: int) -> String:
	return SAVE_DIR + "slot_%d.json" % slot

# --- Save current slot ---
func save_data() -> void:
	if current_slot == -1:
		push_error("No save slot selected")
		return

	var file = FileAccess.open(_slot_path(current_slot), FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(contents, "\t"))
		file.close()
	else:
		push_error("Failed to open save file for writing")

# --- Load a specific slot ---
func load_data(slot: int) -> bool:
	var path = _slot_path(slot)
	if not FileAccess.file_exists(path):
		push_warning("Save slot %d does not exist" % slot)
		return false

	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		push_error("Failed to open save file for reading")
		return false

	var json = JSON.new()
	var err = json.parse(file.get_as_text())
	file.close()

	if err != OK:
		push_error("Failed to parse save file: " + json.get_error_message())
		return false

	var data = json.get_data()
	if data is Dictionary:
		# Merge into contents, preserving new default keys
		for key in data.keys():
			contents[key] = data[key]
		current_slot = slot
		return true
	else:
		push_warning("Save slot %d is corrupted" % slot)
		return false

# --- Create a new save in a slot ---
func new_save(slot: int, player_name: String) -> void:
	current_slot = slot
	contents = {
		"player_name": player_name,
		"current_level": 0,
		"coins": 0
	}
	save_data()

# --- Delete a slot ---
func delete_save(slot: int) -> void:
	var path = _slot_path(slot)
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(path)

# --- Get a summary of all slots for the slot-select screen ---
func get_all_slots() -> Array:
	var slots = []
	for i in range(MAX_SLOTS):
		var path = _slot_path(i)
		if FileAccess.file_exists(path):
			var file = FileAccess.open(path, FileAccess.READ)
			if file:
				var json = JSON.new()
				if json.parse(file.get_as_text()) == OK:
					var data = json.get_data()
					slots.append({
						"slot": i,
						"exists": true,
						"player_name": data.get("player_name", "Unknown"),
						"current_level": data.get("current_level", 0),
						"coins": data.get("coins", 0)
					})
				file.close()
				continue
		# Empty slot
		slots.append({"slot": i, "exists": false})
	return slots
