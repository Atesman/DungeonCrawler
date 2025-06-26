extends Node

const Player = preload("res://scripts/characters/player/Player.gd")
const Enemy = preload("res://scripts/characters/enemies/Enemy.gd")

var player_node: Player = null
var player_starting_data: Dictionary = {}
var current_enemies: Array[Enemy] = [null]

var current_floor: int = 1
var enemy_list: Array = [["orc"]]


func create_new_player(data: Dictionary) -> void:
	player_starting_data = data
	player_node = Player.new()
	player_node.create_player(data)


func get_player() -> Player:
	return player_node


func create_current_enemies():
	var enemies: Array[Enemy] = []
	for enemy in enemy_list[current_floor - 1]:
		var blueprint = parse_class_selection("res://data/enemies/%s.json" % enemy)
		var new_enemy = create_new_enemy(blueprint)
		enemies.append(new_enemy)
	current_enemies = enemies


func create_new_enemy(data: Dictionary) -> Enemy:
	var enemy = Enemy.new()
	enemy.create_enemy(data)
	return enemy


func get_current_enemies() -> Array[Enemy]:
	return current_enemies


func parse_class_selection(class_path: String) -> Dictionary:
	var character_class: FileAccess = FileAccess.open(class_path, FileAccess.READ)
	var classText: String = character_class.get_as_text()
	var blueprint: Variant = JSON.parse_string(classText)

	if typeof(blueprint) == TYPE_DICTIONARY:
		return blueprint
	else:
		push_error("Invalid JSON structure")
		return {}
