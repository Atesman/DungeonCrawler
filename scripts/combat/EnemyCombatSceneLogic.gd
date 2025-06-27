extends Node2D

@export var enemy_ref: Node

@onready var enemy_sprite: Sprite2D = $Sprite


func _ready() -> void:
	_update_sprite()


func _update_sprite():
	var path = enemy_ref.get("sprite_path")
	if path != "":
		var sprite_texture = load(path)
		enemy_sprite.texture = sprite_texture


func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		var manager = get_tree().root.get_node("Main/GameLayer/Dungeon/CombatManager")
		manager.on_enemy_clicked(enemy_ref)
