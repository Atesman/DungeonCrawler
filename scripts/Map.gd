extends Node
class_name Map


func _ready():
	SoundManager.stop_music()
	SoundManager.play_music("map")


func _on_button_pressed():
	SceneManager.transition_scene("res://scenes/combat/Dungeon.tscn")
