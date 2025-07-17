extends Node


func _on_map_button_pressed():
	SceneManager.clear_ui()
	SceneManager.clear_overlay()
	SceneManager.transition_scene("res://scenes/Map.tscn")