# AchievementManager.gd
extends Node

signal achievement_unlocked(achievement: Dictionary)

const COIN_ACHIEVEMENTS  = ["hand_midas_1", "hand_midas_2", "hand_midas_3"]
const LEVEL_ACHIEVEMENTS = ["herald", "crusader", "Immortal"]
const KILL_ACHIEVEMENTS = ["urn_of_shadow", "spirit_vessel", "culling_blade"]

# ── Public API ───────────────────────────────────────────────

func on_coins_changed(total_coins: int) -> void:
	for id in COIN_ACHIEVEMENTS:
		_try_unlock(id, { "coins": total_coins })

func on_level_finished(level: int) -> void:
	for id in LEVEL_ACHIEVEMENTS:
		_try_unlock(id, { "level_finished": level })
		
func on_enemy_killed_changed(total_kills: int) -> void:
	for id in KILL_ACHIEVEMENTS:
		_try_unlock(id, { "enemy_killed": total_kills })

# ── Internals ────────────────────────────────────────────────

func _try_unlock(id: String, ctx: Dictionary) -> void:
	if _is_unlocked(id):
		return
	if _meets_condition(id, ctx):
		_unlock(id)

func _is_unlocked(id: String) -> bool:
	return id in SaveLoad.data["unlocked_achievements"]

func _unlock(id: String) -> void:
	SaveLoad.data["unlocked_achievements"].append(id)
	SaveLoad.save_slot()
	achievement_unlocked.emit(_get_achievement(id))

# Returns true if the achievement's condition is satisfied
func _meets_condition(id: String, ctx: Dictionary) -> bool:
	match id:
		"hand_midas_1": return ctx.get("coins", 0) >= 100
		"hand_midas_2": return ctx.get("coins", 0) >= 200
		"hand_midas_3": return ctx.get("coins", 0) >= 300

		"herald":       return ctx.get("level_finished", -1) >= 1
		"crusader":     return ctx.get("level_finished", -1) >= 10
		"immortal":     return ctx.get("level_finished", -1) >= 20

		"urn_of_shadow":   return ctx.get("enemy_killed", 0) >= 10
		"spirit_vessel":   return ctx.get("enemy_killed", 0) >= 15
		"culling_blade":   return ctx.get("enemy_killed", 0) >= 20

	return false

# Finds the full achievement dictionary from AchievementList by id
func _get_achievement(id: String) -> Dictionary:
	for a in AchievementList.achievements:
		if a["id"] == id:
			return a
	return {}

# Debug: prints all currently unlocked achievements to the console
func debug_print_unlocked() -> void:
	var caller = get_stack()[1]
	print("[AchievementManager.debug_print_unlocked] called from %s line %d" % [caller["source"], caller["line"]])
	var unlocked = SaveLoad.data["unlocked_achievements"]
	if unlocked.is_empty():
		print("  No achievements unlocked.")
		return
	print("  Unlocked achievements:")
	for id in unlocked:
		var achievement = _get_achievement(id)
		print("  - %s: %s" % [achievement.get("title", id), achievement.get("description", "")])
