extends Node
class_name IntentDisplay

@export var target: Node

@onready var container = $MarginContainer
@onready var label = $MarginContainer/Label

const X_OFFSET := 0
const Y_OFFSET := -155


func _ready():

	target.intent_changed.connect(_on_intent_changed)
	#label.text = "MEL: %d" % [target.current_melee_atk]
	position_action_values()


func _on_intent_changed(current_intent: String) -> void:
	label.text = current_intent


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