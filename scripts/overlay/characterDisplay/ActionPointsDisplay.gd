extends Node
class_name ActionPointsDisplay

@export var target: Node

@onready var container = $MarginContainer
@onready var label = $MarginContainer/Label

const X_OFFSET := -252
const Y_OFFSET := 160


func _ready():

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
