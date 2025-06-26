extends Control

@export var character: Node

const Enemy = preload("res://scripts/characters/enemies/Enemy.gd")
const HealthBarScene := preload("res://scenes/overlay/characterDisplay/HealthBar.tscn")
const ActionPointsDisplayScene := preload("res://scenes/overlay/characterDisplay/ActionPointsDisplay.tscn")
const DefenseDisplayScene := preload("res://scenes/overlay/characterDisplay/DefenseDisplay.tscn")
const MeleeDisplayScene := preload("res://scenes/overlay/characterDisplay/MeleeDisplay.tscn")
const RangedDisplayScene := preload("res://scenes/overlay/characterDisplay/RangedDisplay.tscn")
const BlockDisplayScene := preload("res://scenes/overlay/characterDisplay/BlockDisplay.tscn")
const IntentDisplayScene := preload("res://scenes/overlay/characterDisplay/IntentDisplay.tscn")


func _ready():
	if character:
		var health_bar = HealthBarScene.instantiate()
		health_bar.target = character
		add_child(health_bar)

		var ap_display = ActionPointsDisplayScene.instantiate()
		ap_display.target = character
		add_child(ap_display)

		var def_display = DefenseDisplayScene.instantiate()
		def_display.target = character
		add_child(def_display)

		var melee_display = MeleeDisplayScene.instantiate()
		melee_display.target = character
		add_child(melee_display)

		var ranged_display = RangedDisplayScene.instantiate()
		ranged_display.target = character
		add_child(ranged_display)

		var block_display = BlockDisplayScene.instantiate()
		block_display.target = character
		add_child(block_display)

		if character is Enemy:
			var intent_display = IntentDisplayScene.instantiate()
			intent_display.target = character
			add_child(intent_display)


