extends Control

@export var character: Node

const Enemy = preload("res://scripts/characters/enemies/Enemy.gd")
const HealthBarScene := preload("res://scenes/overlay/characterDisplay/HealthBar.tscn")
const ActionPointsDisplayScene := preload("res://scenes/overlay/characterDisplay/ActionPointsDisplay.tscn")
const DefenseDisplayScene := preload("res://scenes/overlay/characterDisplay/DefenseDisplay.tscn")
const MeleeDisplayScene := preload("res://scenes/overlay/characterDisplay/MeleeDisplay.tscn")
const RangedDisplayScene := preload("res://scenes/overlay/characterDisplay/RangedDisplay.tscn")
const BlockDisplayScene := preload("res://scenes/overlay/characterDisplay/BlockDisplay.tscn")
const ActionDisplayScene := preload("res://scenes/overlay/characterDisplay/ActionDisplay.tscn")
const IntentDisplayScene := preload("res://scenes/overlay/characterDisplay/IntentDisplay.tscn")


var health_bar: Node
var ap_display: Node
var def_display: Node
var melee_display: Node
var ranged_display: Node
var block_display: Node
var action_display: Node
var intent_display: Node


func _ready():
	if character:
		health_bar = HealthBarScene.instantiate()
		health_bar.target = character
		add_child(health_bar)

		ap_display = ActionPointsDisplayScene.instantiate()
		ap_display.target = character
		add_child(ap_display)

		def_display = DefenseDisplayScene.instantiate()
		def_display.target = character
		add_child(def_display)

		melee_display = MeleeDisplayScene.instantiate()
		melee_display.target = character
		add_child(melee_display)

		ranged_display = RangedDisplayScene.instantiate()
		ranged_display.target = character
		add_child(ranged_display)

		block_display = BlockDisplayScene.instantiate()
		block_display.target = character
		add_child(block_display)

		action_display = ActionDisplayScene.instantiate()
		action_display.target = character
		add_child(action_display)

		if character is Enemy:
			intent_display = IntentDisplayScene.instantiate()
			intent_display.target = character
			add_child(intent_display)


func update_positions(target_anchor: Vector2):
	health_bar.update_position(target_anchor)
	ap_display.update_position(target_anchor)
	def_display.update_position(target_anchor)
	melee_display.update_position(target_anchor)
	ranged_display.update_position(target_anchor)
	block_display.update_position(target_anchor)
	action_display.update_position(target_anchor)
	if character is Enemy:
		intent_display.update_position(target_anchor)


func fade_all_children(root: Node, to_alpha: float, tween: Tween, duration: float = 0.15):
	for child in root.get_children():
		if child is CanvasItem:
			var from_color = child.modulate
			var to_color = from_color
			to_color.a = to_alpha
			tween.parallel().tween_property(child, "modulate", to_color, duration)
		fade_all_children(child, to_alpha, tween, duration)  # Recursively apply parallel tweening


func begin_movement_animation():
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	fade_all_children(health_bar, 0.0, tween)
	fade_all_children(ap_display, 0.0, tween)
	fade_all_children(def_display, 0.0, tween)
	fade_all_children(melee_display, 0.0, tween)
	fade_all_children(ranged_display, 0.0, tween)
	fade_all_children(block_display, 0.0, tween)
	if intent_display:
		fade_all_children(intent_display, 0.0, tween)


func end_movement_animation():
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	fade_all_children(health_bar, 1.0, tween)
	fade_all_children(ap_display, 1.0, tween)
	fade_all_children(def_display, 1.0, tween)
	fade_all_children(melee_display, 1.0, tween)
	fade_all_children(ranged_display, 1.0, tween)
	fade_all_children(block_display, 1.0, tween)
	if intent_display:
		fade_all_children(intent_display, 1.0, tween)


