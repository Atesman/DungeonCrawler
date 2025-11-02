extends Node

const EnemyFactory = preload("res://scripts/characters/enemies/EnemyFactory.gd")
const GameState = preload("res://globals/GameState.gd")

var current_game_state = null

func _ready() -> void:
	pass


func start_run(player_class: String):
	current_game_state = GameState.new()
	add_child(current_game_state)
	var string = "res://data/classes/%s.json" % player_class
	var starting_player_stats = EnemyFactory.parse_class_selection(string)
	current_game_state.create_new_player(starting_player_stats)
	current_game_state.create_map()
	SceneManager.clear_ui()
	#SoundManager.fade_out(0.5)
	await SceneManager.transition_scene("res://scenes//map/Map.tscn")


func end_run():
	current_game_state.queue_free()
	current_game_state = null