extends Node

@export var target: Node

@onready var action_icon = $TextureRect

var tween: Tween
var PLAYER_X_OFFSET := 90
var X_OFFSET := -270
var Y_OFFSET := -120

const FADE_TIME := 0.2
const VISIBLE_TIME := 0.1


func _ready():
	if target == RunManager.current_game_state.get_player():
		X_OFFSET = PLAYER_X_OFFSET
	action_icon.modulate.a = 0.0
	position_action_values()


func position_action_values():
	var dungeon = get_tree().root.get_node("Main/GameLayer/Dungeon")
	var target_anchor = dungeon.actor_spawn_points.get(target)
	var world_position = target_anchor.global_position
	var canvas_xform = get_viewport().get_canvas_transform()
	var screen_position = canvas_xform * world_position
	
	action_icon.position = Vector2(
		screen_position.x - ((action_icon.size.x * 0.5) + X_OFFSET),
		screen_position.y + Y_OFFSET
	)


func update_position(target_anchor: Vector2):
	var canvas_xform = get_viewport().get_canvas_transform()
	var screen_position = canvas_xform * target_anchor
	
	action_icon.position = Vector2(
		screen_position.x - ((action_icon.size.x * 0.5) + X_OFFSET),
		screen_position.y + Y_OFFSET
	)


func show_action(action: String):
	var path: String
	match action:
		"defend":
			path = "res://assets/ui/intent_defend.png"
		"melee":
			path = "res://assets/ui/intent_melee.png"
		"ranged":
			path = "res://assets/ui/intent_ranged.png"
		
	action_icon.texture = load(path)
	action_icon.modulate.a = 0.0
	show_icon()


func show_icon():
	if tween and tween.is_valid():
		tween.kill()
	
	tween = create_tween()
	tween.tween_property(action_icon, "modulate:a", 0.85, FADE_TIME).set_trans(Tween.TRANS_SINE)
	tween.tween_interval(VISIBLE_TIME)
	tween.tween_property(action_icon, "modulate:a", 0.0, FADE_TIME).set_trans(Tween.TRANS_SINE)