extends Node
class_name ActionPointsDisplay

@export var target: Node

@onready var container = $MarginContainer
@onready var label = $MarginContainer/Label

var PLAYER_X_OFFSET := 115
var X_OFFSET := -252
var Y_OFFSET := 160


func _ready():
	#if target is player or enemy then change x/y offsets
	if target == RunManager.current_game_state.get_player():
		X_OFFSET = PLAYER_X_OFFSET
	target.ap_changed.connect(_on_ap_changed)
	label.text = "ACT: %d / %d" % [target.current_actions, target.max_actions]
	position_action_values()


func _on_ap_changed(current_hp: int) -> void:
	label.text = "ACT: %d / %d" % [target.current_actions, target.max_actions]


func position_action_values():
	var dungeon = get_tree().root.get_node("Main/GameLayer/Dungeon")
	var target_anchor = dungeon.actor_spawn_points.get(target)
	var world_position = target_anchor.global_position
	var canvas_xform = get_viewport().get_canvas_transform()
	var screen_position = canvas_xform * world_position
	
	container.position = Vector2(
		screen_position.x - ((container.size.x * 0.5) + X_OFFSET),
		screen_position.y + Y_OFFSET
	)


func update_position(target_anchor: Vector2):
	var canvas_xform = get_viewport().get_canvas_transform()
	var screen_position = canvas_xform * target_anchor
	
	container.position = Vector2(
		screen_position.x - ((container.size.x * 0.5) + X_OFFSET),
		screen_position.y + Y_OFFSET
	)