extends Node

@export var target: Node

const EffectInfo = preload("res://scenes/overlay/characterDisplay/EffectInfo.tscn")

@onready var container = $VBoxContainer
@onready var status_bar = $VBoxContainer/StatusBar
@onready var texture_rect = $VBoxContainer/StatusBar/TextureRect

var Y_OFFSET := 180
var X_OFFSET := 140


func _ready() -> void:
	position_status_bar()
	target.effects_manager.effect_added.connect(_on_effect_added)


func _on_effect_added(effect: Node):

	var effect_icon = EffectInfo.instantiate()
	effect_icon.effect_ref = effect
	status_bar.add_child(effect_icon)



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
