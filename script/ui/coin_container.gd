extends Panel

@onready var coin_label = $CoinLabel
var coins_amount = 0
func _ready() -> void:
	coins_amount = SaveLoad.data['coins'] as int
	update_display()

func picked_up_coins():
	coins_amount += 1
	update_display()

func update_display():
	coin_label.text = str(coins_amount)
