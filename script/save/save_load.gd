extends Node
const save_location = "user://SaveFile.json"
var contents: Dictionary = {
	"coins": 0 
}

func _ready() -> void:
	load_data()
	
func save_data():
	var file = FileAccess.open(save_location, FileAccess.WRITE)
	if file:
		file.store_var(contents)
		file.close()
	else:
		push_error("Failed to open save file for writing")
	
func load_data():
	if FileAccess.file_exists(save_location):
		var file = FileAccess.open(save_location, FileAccess.READ)
		if file:
			var data = file.get_var()
			file.close()
			
			# Validate that we got a Dictionary
			if data is Dictionary:
				# Merge loaded data into contents, preserving any new keys
				for key in data.keys():
					contents[key] = data[key]
			else:
				push_warning("Save file corrupted or invalid format")
		else:
			push_error("Failed to open save file for reading")
