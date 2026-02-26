extends Label


#coins = 10pts
#enemy = +20pts
#boss = +200pts
#coding zone completion = +30pts
@export var max_pts_lvl := 0
func _ready() -> void:
	SaveLoad.points_changed.connect(_update_label)
	SaveLoad.max_lvl_pts = max_pts_lvl

func _update_label():
	text = str(SaveLoad.current_lvl_pts)
