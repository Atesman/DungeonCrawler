extends Node


func _on_map_button_pressed():
	SceneManager.clear_ui()
	SceneManager.clear_overlay()
	SceneManager.change_scene("res://scenes/Map.tscn")