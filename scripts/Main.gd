extends Node

const EnemyFactory = preload("res://scripts/characters/enemies//EnemyFactory.gd")

@onready var game_layer := $GameLayer
@onready var ui_layer := $UILayer
@onready var overlay_layer := $OverlayLayer


func _ready():
	SceneManager.set_game_layer(game_layer)
	SceneManager.set_overlay_layer(overlay_layer)
	SceneManager.set_ui_layer(ui_layer)
	EnemyFactory.load_enemy_pools()
	call_deferred("load_start_screen")


func load_start_screen():
	SceneManager.change_ui("res://scenes/ui/StartScreen.tscn")
