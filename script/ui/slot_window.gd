extends Panel

# ----------------------------- 
# CONSTANTS
# ----------------------------- 
const SPIN_INTERVAL := 0.08
const SPIN_DELAY := 0.2
const WIN_REWARD := 15
const SPIN_RANGE := Vector2i(6, 15)

const ANIMATIONS := ["blue", "green", "red", "yellow"]

# ----------------------------- 
# EXPORTS
# ----------------------------- 
@export var spin_cost: int = 1

# ----------------------------- 
# NODES
# ----------------------------- 
@onready var slot_label := $SlotLabel
@onready var reels: Array[AnimatedSprite2D] = [
	$SlotSprite1,
	$SlotSprite2,
	$SlotSprite3,
]
@onready var coin_container = get_tree().current_scene.get_node("UI/CanvasLayer/CoinContainer")
@onready var output_label = $OutputPanel/OutputLabel
@onready var output_panel = $OutputPanel
@onready var particles = $CPUParticles2D
# ----------------------------- 
# STATE
# ----------------------------- 
var is_spinning := false

# ----------------------------- 
# LIFECYCLE
# ----------------------------- 
func _ready() -> void:
	slot_label.visible = false
	output_panel.visible = false

# ----------------------------- 
# INPUT
# ----------------------------- 
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_editor") and slot_label.visible:
		spin_slot()

# ----------------------------- 
# PROXIMITY LABEL
# ----------------------------- 
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		slot_label.visible = true
		output_panel.visible = true
		output_label.text = "Spin for a chance 
to win +%d coins!" %WIN_REWARD

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		slot_label.visible = false
		output_panel.visible = false

# ----------------------------- 
# COIN HELPERS
# ----------------------------- 
func _has_enough_coins() -> bool:
	return SaveLoad.data["coins"] >= spin_cost

func _deduct_coins() -> void:
	SaveLoad.data["coins"] -= spin_cost
	SaveLoad.save_slot()
	coin_container.update_display_using_savefile()

func _award_coins(amount: int) -> void:
	SaveLoad.data["coins"] += amount
	SaveLoad.save_slot()
	coin_container.update_display_using_savefile()
	particles.restart()

# ----------------------------- 
# SLOT MACHINE
# ----------------------------- 
func spin_slot() -> void:
	if is_spinning or not _has_enough_coins():
		return

	_deduct_coins()
	is_spinning = true
	output_label.text = "Spinning..."

	await get_tree().create_timer(SPIN_DELAY).timeout

	var results: Array[String] = []
	for reel in reels:
		var result := await _spin_reel(reel)
		results.append(result)

	_evaluate_results(results)
	is_spinning = false

func _spin_reel(reel: AnimatedSprite2D) -> String:
	var spin_count := randi_range(SPIN_RANGE.x, SPIN_RANGE.y)

	for i in spin_count:
		reel.play(ANIMATIONS.pick_random())
		await get_tree().create_timer(SPIN_INTERVAL).timeout

	var final_result = ANIMATIONS.pick_random()
	reel.play(final_result)
	return final_result

func _evaluate_results(results: Array[String]) -> void:
	if _is_winner(results):
		_on_win()
	else:
		_on_lose()

func _is_winner(results: Array[String]) -> bool:
	return results.all(func(r): return r == results[0])

func _on_win() -> void:
	_award_coins(WIN_REWARD)
	output_label.text = "You win! +%d coins" % WIN_REWARD
	

func _on_lose() -> void:
	output_label.text = "No match. \nBetter luck next time!"
