extends Node


func _ready():
	SceneManager.set_game_layer($GameLayer)
	SceneManager.set_ui_layer($UILayer)
	SceneManager.set_overlay_layer($OverlayLayer)
	call_deferred("load_start_screen")

func load_start_screen():
	SceneManager.change_ui("res://scenes/ui/StartScreen.tscn")
