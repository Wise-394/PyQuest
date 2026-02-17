extends Button

func _on_pressed() -> void:
	SaveLoad.delete_slot(0)
	SaveLoad.delete_slot(1)
	SaveLoad.delete_slot(2)
	SaveLoad.delete_slot(3)
