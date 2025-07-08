extends Node2D

@export var character: Node

const Enemy = preload("res://scripts/characters/enemies/Enemy.gd")

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
	var tween := create_tween()
	tween.tween_property(self, "global_position", target_anchor, 0.50).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	await tween.finished


func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		var manager = get_tree().root.get_node("Main/GameLayer/Dungeon/CombatManager")
		manager.on_enemy_clicked(character)


func play_attack_animation():
	SoundManager.play_attack_sound()

	var bounce_distance := Vector2(40, 0)
	var direction := 1

	if character is Enemy:
		direction = -1

	var offset := bounce_distance * direction
	var forward_pos := global_position + offset
	var original_pos := global_position

	var tween := create_tween()
	tween.tween_property(self, "global_position", forward_pos, 0.25).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", original_pos, 0.25).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

	await tween.finished