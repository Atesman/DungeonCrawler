extends Node


func _on_rewards_button_pressed():
	SceneManager.clear_ui()
	SceneManager.add_ui("res://scenes/ui/RewardsScreen.tscn")

func _on_menu_button_pressed():

	RunManager.end_run()

	SceneManager.clear_ui()
	SceneManager.clear_overlay()
	SceneManager.change_scene("res://scenes/ui/MainMenu.tscn")
