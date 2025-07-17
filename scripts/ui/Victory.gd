extends Node


func _ready():
	SoundManager.stop_music()
	SoundManager.play_music("victory")


func _on_rewards_button_pressed():
	SceneManager.clear_ui()
	SceneManager.add_ui("res://scenes/ui/RewardsScreen.tscn")