extends Panel

# ── Exports ────────────────────────────────────────────────────
@export var sprite2d: Texture2D
@export var achievement_id: String
@export var sprite_size: Vector2 = Vector2(64, 64)

# ── Constants ──────────────────────────────────────────────────
const COLOR_UNLOCKED : Color = Color(1, 1, 1, 1)
const COLOR_LOCKED   : Color = Color(0.4, 0.4, 0.4, 1)
const LOCKED_TITLE   : String = "Not Yet Unlocked"
const BOB_HEIGHT     : float = 1.0
const BOB_SPEED      : float = 0.5

# ── Node refs ──────────────────────────────────────────────────
@onready var title_label       = $TitleLabel
@onready var description_label = $DescriptionLabel
@onready var sprite            = $Sprite2D

# ── Internal ───────────────────────────────────────────────────
var _bob_origin : Vector2
var _bobbing    : bool = false

# ── Lifecycle ──────────────────────────────────────────────────
func _ready() -> void:
	var achievement := _get_achievement_by_id(achievement_id)
	if achievement.is_empty():
		push_warning("AchievementPanel: no achievement found with id '%s'" % achievement_id)
		visible = false
		return

	sprite.texture = sprite2d

	if sprite2d and sprite2d.get_size() != Vector2.ZERO:
		var tex_size := sprite2d.get_size()
		sprite.scale = sprite_size / tex_size

	if achievement_id in SaveLoad.get_unlocked_achievements():
		_set_unlocked(achievement)
	else:
		_set_locked(achievement)

func _process(_delta: float) -> void:
	if not _bobbing:
		return
	var offset := sin(Time.get_ticks_msec() * 0.001 * TAU * BOB_SPEED) * BOB_HEIGHT
	sprite.position = _bob_origin + Vector2(0, offset)

# ── States ─────────────────────────────────────────────────────
func _set_unlocked(achievement: Dictionary) -> void:
	title_label.text       = achievement["title"]
	description_label.text = achievement["description"]
	modulate               = COLOR_UNLOCKED
	_bob_origin            = sprite.position
	_bobbing               = true

func _set_locked(achievement: Dictionary) -> void:
	title_label.text       = LOCKED_TITLE
	description_label.text = achievement["description"]
	modulate               = COLOR_LOCKED

# ── Helpers ────────────────────────────────────────────────────
func _get_achievement_by_id(id: String) -> Dictionary:
	for a in AchievementList.achievements:
		if a["id"] == id:
			return a
	return {}
