extends Panel

@onready var sprite          := $Sprite2D
@onready var item_name_label := $ItemNameLabel
@onready var item_cost_label := $ItemCostLabel
@onready var interact_sprite := $InteractSprite
@onready var icon_item_cost  := $IconItemCost

@export var item_id    : String
@export var sprite_img : Texture2D

const BOB_HEIGHT : float = 1.0
const BOB_SPEED  : float = 0.5

var _bob_origin : Vector2
var _bobbing    : bool = false
var is_locked   : bool


# ───────────────────────────── lifecycle ─────────────────────────────

func _ready() -> void:
	sprite.texture       = sprite_img
	interact_sprite.visible = false
	_bob_origin          = sprite.position
	_apply_item_data()
	check_unlock()
	if is_locked:
		locked_state()
	else:
		unlocked_state()


func _process(_delta: float) -> void:
	if not _bobbing:
		return
	var offset := sin(Time.get_ticks_msec() * 0.001 * TAU * BOB_SPEED) * BOB_HEIGHT
	sprite.position = _bob_origin + Vector2(0.0, offset)


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("toggle_editor") or not interact_sprite .visible:
		return
	if is_locked:
		buy_item()
	else:
		equip()


# ───────────────────────────── shop data ─────────────────────────────

func _get_item_data() -> Dictionary:
	for item in ShopList.shop:
		if item["id"] == item_id:
			return item
	push_warning("ShopItem: no data found for id '%s'" % item_id)
	return {}


func _apply_item_data() -> void:
	var data := _get_item_data()
	if data.is_empty():
		return
	item_name_label.text = data.get("name", item_id)


func get_cost() -> int:
	return _get_item_data().get("cost", -1)


# ───────────────────────────── state ─────────────────────────────────

func check_unlock() -> void:
	is_locked = item_id not in SaveLoad.get_unlocked_shop_items()


func locked_state() -> void:
	_bobbing             = true
	item_cost_label.text = str(get_cost())


func unlocked_state() -> void:
	_bobbing                = false
	item_cost_label.visible = false
	icon_item_cost.visible  = false


# ───────────────────────────── buying ────────────────────────────────

func buy_item() -> void:
	var cost := get_cost()
	if cost == -1:
		push_warning("ShopItem: cannot buy '%s', item data missing." % item_id)
		return
	if SaveLoad.data.get("coins", 0) < cost:
		_on_not_enough_coins()
		return
	SaveLoad.data["coins"] -= cost
	SaveLoad.data["unlocked_shop_items"].append(item_id)
	SaveLoad.save_slot()
	SaveLoad.coins_changed.emit(SaveLoad.data["coins"])  # ← add this
	is_locked = false
	unlocked_state()
	equip()


func equip() -> void:
	SaveLoad.data["active_player_skin"] = item_id
	SaveLoad.save_slot()
	SaveLoad.skin_equipped.emit(item_id)


func _on_not_enough_coins() -> void:
	push_warning("ShopItem: not enough coins to buy '%s'." % item_id)


# ───────────────────────────── signals ───────────────────────────────

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		interact_sprite .visible = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		interact_sprite .visible = false
