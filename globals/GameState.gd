extends Node

const Player = preload("res://scripts/characters/player/Player.gd")
const Enemy = preload("res://scripts/characters/enemies/Enemy.gd")
const EnemyFactory = preload("res://scripts/characters/enemies/EnemyFactory.gd")

var player_node: Player = null
var player_starting_data: Dictionary = {}
var current_enemies: Array[Enemy] = [null]

var current_floor: int = 1


func create_new_player(data: Dictionary) -> void:
	player_starting_data = data
	player_node = Player.new(data)
	add_child(player_node)


func get_player() -> Player:
	return player_node


func create_current_enemies():
	var enemy_list = EnemyFactory.get_random_encounter(current_floor)
	var enemies = EnemyFactory.create_enemy_group(enemy_list)
	current_enemies = enemies


func clear_current_enemies():
	current_enemies = [null]


func get_current_enemies() -> Array[Enemy]:
	return current_enemies


func remove_enemy(dead_enemy: BaseCharacter):
	if dead_enemy in current_enemies:
		current_enemies.erase(dead_enemy)
