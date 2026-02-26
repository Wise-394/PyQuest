extends Label


func _ready() -> void:
	SaveLoad.points_changed.connect(_update_label)
	

func _update_label():
	text = str(SaveLoad.current_lvl_pts)
