extends Node

const GameState = preload("res://globals/GameState.gd")

var current_game_state = null

func _ready() -> void:
	pass
	start_run()


func start_run():
	current_game_state = GameState.new()
	
