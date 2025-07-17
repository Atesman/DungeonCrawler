extends Node


func _ready():
	SoundManager.stop_music()
	SoundManager.play_music("defeat")


func _on_menu_button_pressed():

	RunManager.end_run()

	SoundManager.stop_music()
	SoundManager.play_music("main_theme")

	SceneManager.clear_ui()
	SceneManager.clear_overlay()
	SceneManager.transition_scene("res://scenes/MainMenu.tscn")
