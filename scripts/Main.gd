extends Node

const EnemyFactory = preload("res://scripts/characters/enemies//EnemyFactory.gd")


func _ready():
	SceneManager.set_game_layer($GameLayer) ### Set a game screen here that persists through the ui menus that will appear until map, etc
	SceneManager.set_overlay_layer($OverlayLayer)
	SceneManager.set_ui_layer($UILayer)
	EnemyFactory.load_enemy_pools()
	call_deferred("load_start_screen")

func load_start_screen():
	SceneManager.change_ui("res://scenes/ui/StartScreen.tscn")
