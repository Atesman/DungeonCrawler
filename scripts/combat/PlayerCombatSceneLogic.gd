extends Node2D

@onready var player_sprite: Sprite2D = $Sprite

var player_ref: Node = null


func _ready() -> void:
	player_ref = GameState.player_node
	_update_sprite()


func _update_sprite():
	var path = GameState.player_starting_data.get("sprite_path", "")
	if path != "":
		var sprite_texture = load(path)
		player_sprite.texture = sprite_texture

