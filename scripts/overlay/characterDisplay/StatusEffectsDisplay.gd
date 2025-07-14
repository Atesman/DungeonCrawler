extends Node

@export var target: Node

@onready var container = $VBoxContainer
@onready var texture_rect = $VBoxContainer/StatusBar/TextureRect

const Y_OFFSET := 180
var X_OFFSET := 140


func _ready() -> void:
	position_status_bar()
	target.effects_manager.effect_added.connect(_on_effect_added)


func _on_effect_added(effect: Node):
	var texture_path = "res://assets/sprites/%s_icon.png" % effect.ability_name
	var new_texture = load(texture_path)
	if new_texture:
		texture_rect.texture = new_texture


func position_status_bar():
	var dungeon = get_tree().root.get_node("Main/GameLayer/Dungeon")
	var target_anchor = dungeon.actor_spawn_points.get(target)
	var world_position = target_anchor.global_position
	var canvas_xform = get_viewport().get_canvas_transform()
	var screen_position = canvas_xform * world_position
	
	container.position = Vector2(
		screen_position.x - (X_OFFSET),
		screen_position.y + Y_OFFSET
	)


func update_position(target_anchor: Vector2):
	var canvas_xform = get_viewport().get_canvas_transform()
	var screen_position = canvas_xform * target_anchor
	
	container.position = Vector2(
		screen_position.x - (X_OFFSET),
		screen_position.y + Y_OFFSET
	)
