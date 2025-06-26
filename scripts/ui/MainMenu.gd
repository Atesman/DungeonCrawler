extends Control


func _on_warrior_button_pressed():
	var starting_player_stats = GameState.parse_class_selection("res://data/classes/warrior.json")
	GameState.create_new_player(starting_player_stats)
	SceneManager.clear_ui()
	SceneManager.change_scene("res://scenes/Map.tscn")
