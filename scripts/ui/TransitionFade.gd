extends Node

@onready var black_screen = $ColorRect

const fade_duration := 0.4


func fade_out():
	var tween := create_tween()
	tween.tween_property(black_screen, "modulate:a", 1.0, fade_duration)
	await tween.finished


func fade_in():
	var tween := create_tween()
	tween.tween_property(black_screen, "modulate:a", 0.0, fade_duration)
	await tween.finished
