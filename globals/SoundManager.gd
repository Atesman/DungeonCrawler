extends Node

var attack_sound := preload("res://assets/audio/sfx/attack.wav")

var music_player := AudioStreamPlayer.new()
var sfx_player := AudioStreamPlayer.new()


func _ready():
	music_player.bus = "Music"
	sfx_player.bus = "SFX"
	add_child(music_player)
	add_child(sfx_player)


func play_attack_sound():
	sfx_player.stream = attack_sound
	sfx_player.play()	


func play_music(track_name: String): # AudioStream
	var track_path = "res://assets/audio/music/%s.mp3" % track_name
	var stream = load(track_path) as AudioStream
	music_player.stream = stream
	music_player.play()


func stop_music():
	music_player.stop()


func fade_in(track_name: String, fade_duration: float):
	music_player.volume_db = -80
	play_music(track_name)
	var tween := create_tween()
	tween.tween_property(music_player, "volume_db", 0, fade_duration)



func fade_out(fade_duration: float):
	var tween := create_tween()
	tween.tween_property(music_player, "volume_db", -80, fade_duration)
	stop_music()