extends Node
class_name HealthBar

@export var target: Node

@onready var target_bar = $CharacterBar
@onready var label = $CharacterBar/Label

const Y_OFFSET := 150


func _ready():

	target.hp_changed.connect(_on_hp_changed)

	target_bar.max_value = target.max_hp
	target_bar.value = target.current_hp

	label.text = "%d / %d" % [target.current_hp, target.max_hp] # change to display bar.values?

	position_target_bar()


func _on_hp_changed(current_hp: int) -> void:
	target_bar.value = current_hp
	label.text = "%d / %d" % [target.current_hp, target.max_hp]


func position_target_bar():
	var dungeon = get_tree().root.get_node("Main/GameLayer/Dungeon")
	var target_anchor = dungeon.actor_spawn_points.get(target)
	var world_position = target_anchor.global_position
	var canvas_xform = get_viewport().get_canvas_transform()
	var screen_position = canvas_xform * world_position
	
	target_bar.position = Vector2(
		screen_position.x - (target_bar.size.x * 0.5),
		screen_position.y + Y_OFFSET
	)


func update_position(target_anchor: Vector2):
	var canvas_xform = get_viewport().get_canvas_transform()
	var screen_position = canvas_xform * target_anchor
	
	target_bar.position = Vector2(
		screen_position.x - (target_bar.size.x * 0.5),
		screen_position.y + Y_OFFSET
	)