extends Label


var coins_amount = 0
func _ready() -> void:
	coins_amount = SaveLoad.contents.coins
	update_display()

func picked_up_coins():
	coins_amount += 1
	update_display()

func update_display():
	text = str(coins_amount)
