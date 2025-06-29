extends Node2D

@export var character: Node

@onready var sprite_node := $Sprite2D

func _ready():
	_initialize_sprite()
	if character != GameState.get_player():
		$Area2D.input_event.connect(_input_event)


func _initialize_sprite():
	var path = character.get("sprite_path")
	if path != "":
		var sprite_texture = load(path)
		sprite_node.texture = sprite_texture


func update_sprite_position(target_anchor: Vector2):
	position = target_anchor


func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		var manager = get_tree().root.get_node("Main/GameLayer/Dungeon/CombatManager")
		manager.on_enemy_clicked(character)
