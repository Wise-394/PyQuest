extends Label

#coins = 10pts
#enemy = +20pts
#boss = +200pts
#coding zone completion = +30pts

@onready var star1 = $Star1  # AnimatedSprite2D
@onready var star2 = $Star2  # AnimatedSprite2D
@onready var star3 = $Star3  # AnimatedSprite2D

func _ready() -> void:
	text = str(SaveLoad.current_lvl_pts) + "pts"
	update_stars()

func update_stars() -> void:
	var current = SaveLoad.current_lvl_pts
	var max_pts = SaveLoad.max_lvl_pts
	var ratio = float(current) / float(max_pts)
	
	var stars_earned = 0
	if ratio >= 0.7:
		stars_earned = 3
	elif ratio >= 0.5:
		stars_earned = 2
	elif ratio >= 0.1:
		stars_earned = 1

	_set_star(star1, stars_earned >= 1)
	_set_star(star2, stars_earned >= 2)
	_set_star(star3, stars_earned >= 3)

func _set_star(star: AnimatedSprite2D, earned: bool) -> void:
	star.visible = true
	if earned:
		star.modulate = Color(1, 1, 1, 1)  # Full color
		star.play("default")                  # Your animation name
	else:
		star.modulate = Color(0.3, 0.3, 0.3, 1)  # Grayed out
		star.stop()
		star.frame = 0                      # Show first frame, no animation
