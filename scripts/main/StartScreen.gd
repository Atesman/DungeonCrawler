extends Control

func _ready():
	#await get_tree().create_timer(1.0).timeout
	SoundManager.play_music("main_theme")
	#SoundManager.fade_in("main_theme", 0.1)


func _on_start_button_pressed():
	SceneManager.transition_scene("res://scenes/main/MainMenu.tscn")
