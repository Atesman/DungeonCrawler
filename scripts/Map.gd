extends Node
class_name Map

@onready var label = $Label


func _ready():
	label.text = "Current Dungeon Floor - %d" % RunManager.current_game_state.current_floor
	SoundManager.stop_music()
	SoundManager.play_music("map")


func _on_button_pressed():
	SceneManager.transition_scene("res://scenes/combat/Dungeon.tscn")
