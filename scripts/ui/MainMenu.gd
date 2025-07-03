extends Control

const EnemyFactory = preload("res://scripts/characters/enemies//EnemyFactory.gd")


func _on_warrior_button_pressed():
	var starting_player_stats = EnemyFactory.parse_class_selection("res://data/classes/warrior.json")
	GameState.create_new_player(starting_player_stats)
	SceneManager.clear_ui()
	SceneManager.change_scene("res://scenes/Map.tscn")
