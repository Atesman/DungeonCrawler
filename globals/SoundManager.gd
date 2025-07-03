extends Node

var attack_sound := preload("res://assets/audio/sfx/attack.wav")
var music_track := preload("res://assets/audio/sfx/attack.wav")

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

func play_music(track: AudioStream):
	music_player.stream = track
	music_player.play()

func stop_music():
	music_player.stop()
