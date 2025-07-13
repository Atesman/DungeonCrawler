extends Node
class_name EnemyFactory

const Enemy = preload("res://scripts/characters/enemies/Enemy.gd")

static var enemy_pools := {}


static func load_enemy_pools():
	var path = "res://data/enemy_pools.json"
	var file = FileAccess.open(path, FileAccess.READ)
	var json = file.get_as_text()
	var parsed = JSON.parse_string(json)
	if typeof(parsed) == TYPE_DICTIONARY:
		enemy_pools = parsed
	else:
		push_error("Invalid encounter data")


static func get_random_encounter(floor: int) -> Array:
	var encounters: Array = enemy_pools.get(str(floor), [])
	var total = 0.0
	for entry in encounters:
		total += entry["weight"]
	var r = randf() * total
	var running = 0.0
	for entry in encounters:
		running += entry["weight"]
		if r <= running:
			return entry["enemies"]
	return encounters[-1]["enemies"]


static func create_enemy_group(enemy_list: Array) -> Array[Enemy]:
	var enemies: Array[Enemy] = []
	for enemy in enemy_list:
		var blueprint = parse_class_selection("res://data/enemies/%s.json" % enemy)
		var new_enemy = create_new_enemy(blueprint)
		enemies.append(new_enemy)
	return enemies


static func create_new_enemy(data: Dictionary) -> Enemy:
	var enemy = Enemy.new(data)
	#enemy.create_enemy(data)
	return enemy


static func parse_class_selection(class_path: String) -> Dictionary:
	var character_class: FileAccess = FileAccess.open(class_path, FileAccess.READ)
	var classText: String = character_class.get_as_text()
	var blueprint: Variant = JSON.parse_string(classText)

	if typeof(blueprint) == TYPE_DICTIONARY:
		return blueprint
	else:
		push_error("Invalid JSON structure")
		return {}
