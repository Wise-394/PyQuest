
extends Node
class_name ShopList

const shop: Array[Dictionary] = [
	{
		"id": "player_default_skin",
		"name": "Classic",
		"cost": 0,
		"file_path" : "res://tres/player_default_skin.tres"
	},
	{
		"id": "player_red_skin",
		"name": "Red Pirate",
		"cost": 100,
		"file_path" : "res://tres/player_red_skin.tres"
	},
	{
		"id": "player_blue_skin",
		"name": "blue Pirate",
		"cost": 150,
		"file_path" : "res://tres/player_blue_skin.tres"
	}
	
]
static func get_item(id: String) -> Dictionary:
	for item in shop:
		if item["id"] == id:
			return item
	push_warning("ShopList: no item found for id '%s'" % id)
	return {}
