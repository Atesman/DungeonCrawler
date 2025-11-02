extends Node

@onready var game_layer := $GameLayer
@onready var ui_layer := $UILayer
@onready var overlay_layer := $OverlayLayer


func _ready():
	randomize()
	SceneManager.set_game_layer(game_layer)
	SceneManager.set_overlay_layer(overlay_layer)
	SceneManager.set_ui_layer(ui_layer)
	call_deferred("load_start_screen")


func load_start_screen():
	SceneManager.transition_scene("res://scenes/main/StartScreen.tscn")
