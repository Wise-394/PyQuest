extends Panel

# ── Exports ──────────────────────────────────────────────────
@export var sprite2d: Texture2D
@export var achievement_id: String

# ── Constants ────────────────────────────────────────────────
const COLOR_UNLOCKED : Color = Color(1, 1, 1, 1)
const COLOR_LOCKED   : Color = Color(0.4, 0.4, 0.4, 1)
const LOCKED_TITLE   : String = "Not Yet Unlocked"

# ── Node refs ────────────────────────────────────────────────
@onready var title_label       = $TitleLabel
@onready var description_label = $DescriptionLabel

# ── Lifecycle ────────────────────────────────────────────────
func _ready() -> void:
	var achievement := _get_achievement_by_id(achievement_id)

	if achievement.is_empty():
		push_warning("AchievementPanel: no achievement found with id '%s'" % achievement_id)
		visible = false
		return

	if achievement_id in SaveLoad.get_unlocked_achievements():
		_set_unlocked(achievement)
	else:
		_set_locked(achievement)

# ── States ───────────────────────────────────────────────────
func _set_unlocked(achievement: Dictionary) -> void:
	title_label.text       = achievement["title"]
	description_label.text = achievement["description"]
	modulate               = COLOR_UNLOCKED

func _set_locked(achievement: Dictionary) -> void:
	title_label.text       = LOCKED_TITLE
	description_label.text = achievement["description"]
	modulate               = COLOR_LOCKED

# ── Helpers ──────────────────────────────────────────────────
func _get_achievement_by_id(id: String) -> Dictionary:
	for a in AchievementList.achievements:
		if a["id"] == id:
			return a
	return {}
