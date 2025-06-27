extends Node
class_name DefenseDisplay

@export var target: Node

@onready var container = $MarginContainer
@onready var label = $MarginContainer/Label

var PLAYER_X_OFFSET := 115
var X_OFFSET := -252
var Y_OFFSET := 135


func _ready():
	if target == GameState.get_player():
		X_OFFSET = PLAYER_X_OFFSET
	target.def_changed.connect(_on_def_changed)
	label.text = "DEF: %d" % [target.current_def]
	position_action_values()


func _on_def_changed(current_def: int) -> void:
	label.text = "DEF: %d" % [target.current_def]


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